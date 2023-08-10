use std::fmt::Display;

use super::user_info::{UserInfoTrait, UserLoginInfo};

// 认证器
pub struct Authenticator;

// 授权器
pub struct Authorizer;

#[async_trait::async_trait]
pub trait AuthenticatorTrait<U>
where
    U: Display + UserInfoTrait,
{
    async fn authenticate(info: UserLoginInfo) -> U {
        println!(
            "[user-login-info] : name: {}, password: {}",
            info.username, info.password
        );

        let u = U::new(Some(0), None);

        return u;
    }
}

pub trait AuthenticatorTraitSync<U>
where
    U: Display + UserInfoTrait,
{
    fn authenticate(info: UserLoginInfo) -> U {
        println!(
            "[user-login-info] : name: {}, password: {}",
            info.username, info.password
        );
        let u = U::new(Some(0), None);

        return u;
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
    pub async fn authenticate(&self, info: UserLoginInfo) {
        let u = <T as AuthenticatorTrait<U>>::authenticate(info).await;
        println!("{}", u)
    }

    pub fn authenticate_sync(&self, info: UserLoginInfo) {
        <T as AuthenticatorTraitSync<U>>::authenticate(info);
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
