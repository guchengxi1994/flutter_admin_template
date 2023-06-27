use std::time::SystemTime;

use crate::constants::TOKEN_EXPIRE;
use crate::models::sign_in_record::SignInState;
use crate::{database::init::REDIS_CLIENT, models::user::User};
use serde::Deserialize;
use validator::Validate;

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

impl User {
    pub async fn new_user(req: NewUserRequest) -> anyhow::Result<()> {
        if let Err(_e) = req.validate() {
            anyhow::bail!("参数错误")
        }
        // TODO
        // 需要增加 dept_id 校验的问题
        let pool = crate::database::init::POOL.lock().unwrap();
        let mut tx = pool.get_pool().begin().await?;
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

    pub async fn login(req: UserLoginRequest, login_ip: String) -> anyhow::Result<String> {
        if let Err(_e) = req.validate() {
            anyhow::bail!("参数错误")
        }

        let pool = crate::database::init::POOL.lock().unwrap();
        let mut tx = pool.get_pool().begin().await?;
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
                        r#"INSERT INTO user_login (user_id,user_name,login_ip,login_state) VALUES (?,?,?,?)"#,
                    )
                    .bind(_u.user_id).bind(_u.user_name)
                    .bind(login_ip)
                    .bind(SignInState::ErrPwd.to_string())
                    .execute(&mut tx)
                    .await?;
                    anyhow::bail!("密码错误")
                }
                let cli = REDIS_CLIENT.lock().unwrap().clone().unwrap();
                let mut con = cli.get_connection().unwrap();
                // 获取最后一次登录的时间和token
                let log = crate::models::sign_in_record::SignInRecord::current_single(
                    _u.user_id,
                    pool.get_pool(),
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
                    r#"INSERT INTO user_login (user_id,user_name,login_ip,login_state,token) VALUES (?,?,?,?,?)"#,
                )
                .bind(_u.user_id).bind(_u.user_name)
                .bind(login_ip)
                .bind(SignInState::Success.to_string()).bind(token.clone())
                .execute(&mut tx)
                .await?;
                tx.commit().await?;

                let _: () = redis::Commands::set(&mut con, token.clone(), _u.user_id)?;
                let d = TOKEN_EXPIRE.lock().unwrap();
                let _: () = redis::Commands::expire(&mut con, token.clone(), *d)?;
                return anyhow::Ok(token);
            }
            Err(_) => {
                println!("[rust error] : 用户不存在");
                let _ = sqlx::query(
                    r#"INSERT INTO user_login (user_id,user_name,login_ip,login_state) VALUES (?,?,?,?)"#,
                )
                .bind(0).bind("unknow")
                .bind(login_ip)
                .bind(SignInState::NoUser.to_string())
                .execute(&mut tx)
                .await?;
                anyhow::bail!("用户不存在")
            }
        }
    }
}
