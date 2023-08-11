use std::{fmt::Display, sync::Mutex};

use lazy_static::lazy_static;

use fat_auth::user_service::{
    auth::{
        Auth, AuthenticatorTrait, AuthenticatorTraitSync, AuthorizerTrait, AuthorizerTraitSync,
    },
    user_info::{UserInfoTrait, UserLoginInfo},
};

use crate::database::init::POOL;

lazy_static! {
    static ref AUTH: Mutex<Option<Auth<FatAuthenticator, FatAuthorizer, FatUserInfo>>> =
        Mutex::new(None);
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
    async fn authenticate(info: UserLoginInfo) -> anyhow::Result<U> {
        let _pool = POOL.lock().unwrap();
        let pool = _pool.get_pool();
        let mut tx = pool.begin().await?;

        if info.username == "abc" && info.password == "123" {
            println!("OK")
        } else {
            println!("ERROR")
        }
        // UserInfo{token:None,user_id:0}
        anyhow::Ok(U::new(Some(0), None))
    }
}

impl<U: Display + UserInfoTrait> AuthenticatorTraitSync<U> for FatAuthenticator {
    fn authenticate(info: UserLoginInfo) -> anyhow::Result<U> {

        if info.username == "abc" && info.password == "123" {
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
