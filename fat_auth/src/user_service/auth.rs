use super::user_info::UserLoginInfo;

// 认证器
pub struct Authenticator;

// 授权器
pub struct Authorizer;

#[async_trait::async_trait]
pub trait AuthenticatorTrait {
    async fn authenticate(info: UserLoginInfo) {
        println!(
            "[user-login-info] : name: {}, password: {}",
            info.username, info.password
        )
    }
}

pub trait AuthenticatorTraitSync {
    fn authenticate(info: UserLoginInfo) {
        println!(
            "[user-login-info] : name: {}, password: {}",
            info.username, info.password
        )
    }
}

impl AuthenticatorTrait for Authenticator {}

impl AuthenticatorTraitSync for Authenticator {}

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

pub struct Auth<T, E>
where
    T: AuthenticatorTrait + AuthenticatorTraitSync,
    E: AuthorizerTrait + AuthorizerTraitSync,
{
    pub authenticator: T,
    pub authorizer: E,
}

impl<T: AuthenticatorTrait + AuthenticatorTraitSync, E: AuthorizerTrait + AuthorizerTraitSync>
    Auth<T, E>
{
    pub async fn authenticate(&self, info: UserLoginInfo) {
        <T as AuthenticatorTrait>::authenticate(info).await;
    }

    pub fn authenticate_sync(&self, info: UserLoginInfo) {
        <T as AuthenticatorTraitSync>::authenticate(info);
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
