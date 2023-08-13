use std::collections::HashSet;

use crate::common::auth::AUTH;
use crate::constants::TOKEN_EXPIRE;
use crate::models::sign_in_record::SignInState;
use crate::{database::init::REDIS_CLIENT_SYNC, models::user::User};
use serde::Deserialize;
use sqlx::{MySql, Pool, QueryBuilder};
use validator::Validate;

use super::api_service::ApiTrait;
use super::query_params::Count;
use super::role_service::RoleTrait;

#[derive(Debug, Validate, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct NewUserRequest {
    pub dept_id: Option<i64>,
    #[validate(length(max = 30))]
    pub user_name: String,
    pub password: String,
    pub create_by: Option<String>,
    #[validate(length(max = 50))]
    pub remark: Option<String>,
}

#[derive(Debug, Validate, Deserialize)]
pub struct UserLoginRequest {
    #[validate(length(max = 30))]
    pub user_name: String,
    pub password: String,
}

#[derive(Debug, Validate, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct UserQueryRequest {
    pub user_name: Option<String>,
    pub user_id: Option<i64>,
    pub create_by: Option<String>,
    pub page_number: i64,
    pub page_size: i64,
}

#[async_trait::async_trait]
pub trait UserTrait {
    async fn new_user(pool: &Pool<MySql>, req: NewUserRequest) -> anyhow::Result<()>;

    async fn get_user_info(pool: &Pool<MySql>, user_id: i64) -> anyhow::Result<User>;

    async fn login(req: UserLoginRequest, login_ip: String) -> anyhow::Result<String>;

    async fn query_by_dept_id(pool: &Pool<MySql>, dept_id: i64) -> anyhow::Result<Vec<User>>;

    async fn query_by_id(pool: &Pool<MySql>, user_id: i64) -> anyhow::Result<User>;

    async fn query_user(
        pool: &Pool<MySql>,
        req: UserQueryRequest,
    ) -> anyhow::Result<super::DataList<User>>;
}

pub struct UserService;

#[async_trait::async_trait]
impl UserTrait for UserService {
    async fn new_user(pool: &Pool<MySql>, req: NewUserRequest) -> anyhow::Result<()> {
        if let Err(_e) = req.validate() {
            anyhow::bail!("参数错误")
        }
        let mut tx = pool.begin().await?;
        if let Err(_) = sqlx::query_as::<sqlx::MySql, User>(
            r#"SELECT * from user where is_deleted = 0 and user_name = ?"#,
        )
        .bind(req.user_name.as_str())
        .fetch_one(&mut tx)
        .await
        {
            let _ = sqlx::query(
                    r#"INSERT INTO user (user_name,dept_id,password,create_by,remark) VALUES (?,?,?,?,?)"#,
                )
                .bind(req.user_name.as_str())
                .bind(req.dept_id)
                .bind(req.password)
                .bind(req.create_by)
                .bind(req.remark)
                .execute(&mut tx)
                .await?;

            tx.commit().await?;
            anyhow::Ok(())
        } else {
            anyhow::bail!("用户已存在")
        }
    }

    async fn get_user_info(pool: &Pool<MySql>, user_id: i64) -> anyhow::Result<User> {
        let u = sqlx::query_as::<sqlx::MySql, User>(
            r#"select * from user where is_deleted = 0 and user_id = ?"#,
        )
        .bind(user_id)
        .fetch_one(pool)
        .await?;

        anyhow::Ok(u)
    }

    async fn login(req: UserLoginRequest, login_ip: String) -> anyhow::Result<String> {
        if let Err(_e) = req.validate() {
            anyhow::bail!("参数错误")
        }
        let u: Result<crate::common::auth::FatUserInfo, anyhow::Error>;

        {
            let _auth = AUTH.lock().await;
            u = _auth
                .authenticate(req.user_name.clone(), req.password.clone())
                .await;
        }

        let pool = crate::database::init::POOL.lock().await;

        match u {
            Ok(_u) => {
                let token = _u.token.unwrap();

                let _ = sqlx::query(
                    r#"INSERT INTO user_login (user_id,login_ip,login_state,token) VALUES (?,?,?,?)"#,
                )
                .bind(_u.user_id.unwrap())
                .bind(login_ip)
                .bind(SignInState::Success.to_string()).bind(token.clone())
                .execute(pool.get_pool())
                .await?;

                // 这里去获取api权限

                // 先去获取role id
                let role_id = super::role_service::RoleService::get_role_id_by_user_id(
                    _u.user_id.unwrap_or(0),
                    pool.get_pool(),
                )
                .await
                .unwrap_or(Some(0));

                let mut api_ids: HashSet<i64> = HashSet::new();
                api_ids.extend([12, 13, 9, 5, 16]);

                if let Some(rid) = role_id {
                    let apis =
                        super::api_service::ApiService::query_by_role_id(rid, pool.get_pool())
                            .await?;
                    for i in apis {
                        api_ids.insert(i.api_id);
                    }
                }
                let cli = REDIS_CLIENT_SYNC.lock().unwrap().clone().unwrap();
                let mut con = cli.get_connection().unwrap();
                let _: () = redis::Commands::set(&mut con, token.clone(), _u.user_id)?;
                let d = TOKEN_EXPIRE.lock().unwrap();
                let _: () = redis::Commands::expire(&mut con, token.clone(), *d)?;

                let api_key = format!("{}_apis", token.clone());
                for i in api_ids {
                    let _: () = redis::Commands::lpush(&mut con, api_key.clone(), i)?;
                }
                let _: () = redis::Commands::expire(&mut con, api_key.clone(), *d)?;

                return anyhow::Ok(token);
            }
            Err(e) => {
                let _ = sqlx::query(
                    r#"INSERT INTO user_login (user_id,login_ip,login_state) VALUES (?,?,?)"#,
                )
                .bind(0)
                .bind(login_ip)
                .bind(e.to_string())
                .execute(pool.get_pool())
                .await?;
                println!("[rust error] : {:?}", e);
                anyhow::bail!(e.to_string())
            }
        }
    }

    async fn query_by_dept_id(pool: &Pool<MySql>, dept_id: i64) -> anyhow::Result<Vec<User>> {
        let result = sqlx::query_as::<sqlx::MySql, User>(
            r#"SELECT
            `user`.user_id,
            `user`.dept_id,
            `user`.user_name,
            `user`.`password`,
            `user`.create_by,
            `user`.create_time,
            `user`.update_time,
            `user`.is_deleted,
            `user`.remark 
        FROM
            `user`
            LEFT JOIN department ON `user`.dept_id = department.dept_id 
        WHERE
            `user`.is_deleted = 0 
            AND department.is_deleted = 0 and department.dept_id = ?"#,
        )
        .bind(dept_id)
        .fetch_all(pool)
        .await?;
        anyhow::Ok(result)
    }

    async fn query_by_id(pool: &Pool<MySql>, user_id: i64) -> anyhow::Result<User> {
        let result = sqlx::query_as(r#"select * from user where is_deleted = 0 and user_id = ?"#)
            .bind(user_id)
            .fetch_one(pool)
            .await?;
        anyhow::Ok(result)
    }

    async fn query_user(
        pool: &Pool<MySql>,
        req: UserQueryRequest,
    ) -> anyhow::Result<super::DataList<User>> {
        let mut query = QueryBuilder::<MySql>::new("select * from user");
        let mut count_query =
            QueryBuilder::<MySql>::new("SELECT COUNT(user_id) as count FROM ( select * from user ");
        if let Some(user_name) = req.user_name {
            query.push(" and user_name LIKE ");
            let l = format!("'%{}%'", user_name);
            query.push(l.clone());

            count_query.push(" and user_name LIKE ");
            count_query.push(l);
        }

        if let Some(user_id) = req.user_id {
            query.push(" and user_id = ");
            query.push_bind(user_id);

            count_query.push(" and user_id = ");
            count_query.push_bind(user_id);
        }

        if let Some(create_by) = req.create_by {
            query.push(" and create_by = ");
            query.push_bind(create_by.clone());

            count_query.push(" and create_by = ");
            count_query.push_bind(create_by);
        }

        count_query.push(" ) as t");

        let count: Count = count_query.build_query_as().fetch_one(pool).await?;

        println!("[query] : {:?}", count_query.sql());

        query.push(" limit");
        query.push_bind((req.page_number - 1) * req.page_size);
        query.push(",");
        query.push_bind(req.page_size);

        let result: Vec<User> = query.build_query_as().fetch_all(pool).await?;

        println!("[query] : {:?}", query.sql());

        anyhow::Ok(super::DataList {
            count: count.count,
            records: result,
        })
    }
}
