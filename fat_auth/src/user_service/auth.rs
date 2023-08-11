use std::fmt::Display;

use super::user_info::UserInfoTrait;

// 认证器
pub struct Authenticator;

// 授权器
pub struct Authorizer;

#[async_trait::async_trait]
pub trait AuthenticatorTrait<U>
where
    U: Display + UserInfoTrait,
{
    async fn authenticate(username: String, password: String) -> anyhow::Result<U> {
        println!(
            "[user-login-info] : name: {}, password: {}",
            username, password
        );

        let u = U::new(Some(0), None);

        return anyhow::Ok(u);
    }
}

pub trait AuthenticatorTraitSync<U>
where
    U: Display + UserInfoTrait,
{
    fn authenticate(username: String, password: String) -> anyhow::Result<U> {
        println!(
            "[user-login-info] : name: {}, password: {}",
            username, password
        );
        let u = U::new(Some(0), None);

        return anyhow::Ok(u);
    }
}

impl<U: Display + UserInfoTrait> AuthenticatorTrait<U> for Authenticator {}

impl<U: Display + UserInfoTrait> AuthenticatorTraitSync<U> for Authenticator {}

#[async_trait::async_trait]
pub trait AuthorizerTrait {
    async fn authorize(uid: i64, resource: String) -> bool {
        println!("uid: {}, resource: {}", uid, resource);
        false
    }
}

pub trait AuthorizerTraitSync {
    fn authorize(uid: i64, resource: String) -> bool {
        println!("uid: {}, resource: {}", uid, resource);
        false
    }
}

impl AuthorizerTrait for Authorizer {}

impl AuthorizerTraitSync for Authorizer {}

pub struct Auth<T, E, U>
where
    T: AuthenticatorTrait<U> + AuthenticatorTraitSync<U>,
    E: AuthorizerTrait + AuthorizerTraitSync,
    U: Display + UserInfoTrait,
{
    pub authenticator: T,
    pub authorizer: E,
    pub storage: Vec<U>,
}

impl<
        T: AuthenticatorTrait<U> + AuthenticatorTraitSync<U>,
        E: AuthorizerTrait + AuthorizerTraitSync,
        U: Display + UserInfoTrait,
    > Auth<T, E, U>
{
    pub async fn authenticate(&self, username: String, password: String)->anyhow::Result<U> {
        let u = <T as AuthenticatorTrait<U>>::authenticate(username, password).await;
        return u;
    }

    pub fn authenticate_sync(&self, username: String, password: String) {
        let u = <T as AuthenticatorTraitSync<U>>::authenticate(username, password);
        match u {
            Ok(_u) => {
                println!("{}", _u);
            }
            Err(_) => {}
        }
    }

    pub async fn authorize(&self, uid: i64, resource: String) -> bool {
        <E as AuthorizerTrait>::authorize(uid, resource).await
    }

    pub fn authorize_sync(&self, uid: i64, resource: String) -> bool {
        <E as AuthorizerTraitSync>::authorize(uid, resource)
    }
}

#[async_trait::async_trait]
pub trait Persistence {
    async fn remember() {}

    fn remember_sync() {}
}
