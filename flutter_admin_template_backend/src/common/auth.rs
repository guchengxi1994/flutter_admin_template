use futures::lock::Mutex;
use std::{fmt::Display, time::SystemTime};

use lazy_static::lazy_static;

use fat_auth::user_service::{
    auth::{
        Auth, AuthenticatorTrait, AuthenticatorTraitSync, AuthorizerTrait, AuthorizerTraitSync,
    },
    user_info::UserInfoTrait,
};

use crate::{
    constants::TOKEN_EXPIRE,
    database::init::{POOL, REDIS_CLIENT_SYNC},
    models::{sign_in_record::SignInState, user::User},
    services::Query,
};

lazy_static! {
    pub static ref AUTH: Mutex<Auth<FatAuthenticator, FatAuthorizer, FatUserInfo>> =
        Mutex::new(Auth {
            authenticator: FatAuthenticator {},
            authorizer: FatAuthorizer {},
            storage: Vec::new()
        });
}

pub struct FatAuthenticator;

pub struct FatAuthorizer;

pub struct FatUserInfo {
    pub user_id: Option<i64>,
    pub token: Option<String>,
}

impl Display for FatUserInfo {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "FatUserInfo : user_id: {:?}, token: {:?}",
            self.user_id, self.token
        )
    }
}

impl UserInfoTrait for FatUserInfo {
    fn new(user_id: Option<i64>, token: Option<String>) -> Self {
        FatUserInfo { user_id, token }
    }
}

#[async_trait::async_trait]
impl<U: Display + UserInfoTrait> AuthenticatorTrait<U> for FatAuthenticator {
    async fn authenticate(username: String, password: String) -> anyhow::Result<U> {
        let _pool = POOL.lock().await;
        let pool = _pool.get_pool();
        let mut tx = pool.begin().await?;
        let u = sqlx::query_as::<sqlx::MySql, User>(
            r#"SELECT * from user where is_deleted = 0 and user_name = ?"#,
        )
        .bind(username.as_str())
        .fetch_one(&mut tx)
        .await;

        match u {
            Ok(_u) => {
                // return anyhow::Ok(U::new(Some(_u.user_id), None));
                if let Err(_) = sqlx::query_as::<sqlx::MySql, User>(
                    r#"SELECT * from user where is_deleted = 0 and user_name = ? AND password = ?"#,
                )
                .bind(username.as_str())
                .bind(password)
                .fetch_one(&mut tx)
                .await
                {
                    anyhow::bail!(SignInState::ErrPwd.to_string())
                }
                let cli = REDIS_CLIENT_SYNC.lock().unwrap().clone().unwrap();
                let mut con = cli.get_connection().unwrap();
                // 获取最后一次登录的时间和token
                let log = crate::services::log_service::SignInRecordWithName::current_single(
                    _u.user_id, pool,
                )
                .await;

                if let Ok(_log) = log {
                    // 如果没有超时
                    let duration = SystemTime::now().duration_since(_log.login_time.into())?;
                    if let Some(t) = _log.token {
                        if let Ok(_id) = crate::database::validate_token::validate_token(t.clone()) {
                            if duration.as_secs() < (*TOKEN_EXPIRE.lock().unwrap()).try_into()? {
                                // 刷新token
                                let _ =
                                    crate::database::refresh_token::refresh_token(t.clone(), &mut con);
                                return anyhow::Ok(U::new(Some(_u.user_id), Some(t)));
                            }
                        }
                    }
                }

                
                tx.commit().await?;

                let token = crate::common::hash::get_token(username);
                return anyhow::Ok(U::new(Some(_u.user_id), Some(token)));
            }
            Err(_) => {
                anyhow::bail!(SignInState::NoUser.to_string())
            }
        }
    }
}

impl<U: Display + UserInfoTrait> AuthenticatorTraitSync<U> for FatAuthenticator {
    fn authenticate(username: String, password: String) -> anyhow::Result<U> {
        if username == "abc" && password == "123" {
            println!("OK")
        } else {
            println!("ERROR")
        }

        anyhow::Ok(U::new(Some(0), None))
    }
}

#[async_trait::async_trait]
impl AuthorizerTrait for FatAuthorizer {
    async fn authorize(uid: i64, resource: String) -> bool {
        if uid == 1 && resource == "/a/b/c" {
            return true;
        }
        false
    }
}

impl AuthorizerTraitSync for FatAuthorizer {
    fn authorize(uid: i64, resource: String) -> bool {
        if uid == 1 && resource == "/a/b/c" {
            return true;
        }
        false
    }
}
