use super::user_info::UserInfo;

// 认证器
pub struct Authenticator;

// 授权器
pub struct Authorizer;

#[async_trait::async_trait]
pub trait AuthenticatorTrait {
    async fn authenticate(info: UserInfo) {
        println!(
            "[userinfo] : name: {}, password: {}",
            info.username, info.password
        )
    }
}

impl AuthenticatorTrait for Authenticator {}

#[async_trait::async_trait]
pub trait AuthorizerTrait {
    async fn authorize(uid: i64, resource: String) -> bool {
        println!("uid: {}, resource: {}", uid, resource);
        false
    }
}

impl AuthorizerTrait for Authorizer {}

pub struct Auth<T, E>
where
    T: AuthenticatorTrait,
    E: AuthorizerTrait,
{
    pub authenticator: T,
    pub authorizer: E,
}

impl<T: AuthenticatorTrait, E: AuthorizerTrait> Auth<T, E> {
    pub async fn authenticate(&self, info: UserInfo) {
        <T as AuthenticatorTrait>::authenticate(info).await;
    }

    pub async fn authorize(&self, uid: i64, resource: String) -> bool {
        <E as AuthorizerTrait>::authorize(uid, resource).await
    }
}
