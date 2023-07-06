use std::collections::HashSet;
use std::time::SystemTime;

use crate::constants::TOKEN_EXPIRE;
use crate::models::sign_in_record::SignInState;
use crate::{database::init::REDIS_CLIENT, models::user::User};
use serde::Deserialize;
use sqlx::{MySql, Pool};
use validator::Validate;

use super::api_service::ApiTrait;
use super::role_service::RoleTrait;
use super::Query;

#[derive(Debug, Validate, Deserialize)]
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

#[async_trait::async_trait]
pub trait UserTrait {
    async fn new_user(pool: &Pool<MySql>, req: NewUserRequest) -> anyhow::Result<()>;

    async fn get_user_info(pool: &Pool<MySql>, user_id: i64) -> anyhow::Result<User>;

    async fn login(
        pool: &Pool<MySql>,
        req: UserLoginRequest,
        login_ip: String,
    ) -> anyhow::Result<String>;
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

    async fn login(
        pool: &Pool<MySql>,
        req: UserLoginRequest,
        login_ip: String,
    ) -> anyhow::Result<String> {
        if let Err(_e) = req.validate() {
            anyhow::bail!("参数错误")
        }
        let mut tx = pool.begin().await?;
        let u = sqlx::query_as::<sqlx::MySql, User>(
            r#"SELECT * from user where is_deleted = 0 and user_name = ?"#,
        )
        .bind(req.user_name.as_str())
        .fetch_one(&mut tx)
        .await;
        match u {
            Ok(_u) => {
                if let Err(_) = sqlx::query_as::<sqlx::MySql, User>(
                    r#"SELECT * from user where is_deleted = 0 and user_name = ? AND password = ?"#,
                )
                .bind(req.user_name.as_str())
                .bind(req.password)
                .fetch_one(&mut tx)
                .await
                {
                    let _ = sqlx::query(
                        r#"INSERT INTO user_login (user_id,login_ip,login_state) VALUES (?,?,?)"#,
                    )
                    .bind(_u.user_id)
                    .bind(login_ip)
                    .bind(SignInState::ErrPwd.to_string())
                    .execute(&mut tx)
                    .await?;
                    anyhow::bail!("密码错误")
                }
                let cli = REDIS_CLIENT.lock().unwrap().clone().unwrap();
                let mut con = cli.get_connection().unwrap();
                // 获取最后一次登录的时间和token
                let log = crate::services::log_service::SignInRecordWithName::current_single(
                    _u.user_id, pool,
                )
                .await?;

                // 如果没有超时
                let duration = SystemTime::now().duration_since(log.login_time.into())?;
                if let Some(t) = log.token {
                    if duration.as_secs() < (*TOKEN_EXPIRE.lock().unwrap()).try_into()? {
                        // 刷新token
                        let _ = crate::database::refresh_token::refresh_token(t.clone(), &mut con);
                        return anyhow::Ok(t);
                    }
                }

                let token = crate::common::hash::get_token(req.user_name);

                let _ = sqlx::query(
                    r#"INSERT INTO user_login (user_id,login_ip,login_state,token) VALUES (?,?,?,?)"#,
                )
                .bind(_u.user_id)
                .bind(login_ip)
                .bind(SignInState::Success.to_string()).bind(token.clone())
                .execute(&mut tx)
                .await?;
                // 这里去获取api权限

                // 先去获取role id
                let role_id =
                    super::role_service::RoleService::get_role_id_by_user_id(_u.user_id, pool)
                        .await.unwrap_or(Some(0));

                let mut api_ids: HashSet<i64> = HashSet::new();
                api_ids.extend([12, 13, 9, 5, 16]);

                if let Some(rid) = role_id {
                    let apis = super::api_service::ApiService::query_by_role_id(rid, pool).await?;
                    for i in apis {
                        api_ids.insert(i.api_id);
                    }
                }

                tx.commit().await?;

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
            Err(_) => {
                println!("[rust error] : 用户不存在");
                let _ = sqlx::query(
                    r#"INSERT INTO user_login (user_id,login_ip,login_state) VALUES (?,?,?)"#,
                )
                .bind(0)
                .bind(login_ip)
                .bind(SignInState::NoUser.to_string())
                .execute(&mut tx)
                .await?;
                anyhow::bail!("用户不存在")
            }
        }
    }
}
