mod tests {
    use std::fmt::Display;

    use crate::user_service::{
        auth::{
            Auth, AuthenticatorTrait, AuthenticatorTraitSync, AuthorizerTrait, AuthorizerTraitSync,
        },
        user_info::{UserInfo, UserInfoTrait, UserLoginInfo},
    };

    pub struct CustomAuthenticator;

    pub struct CustomAuthorizer;

    #[async_trait::async_trait]
    impl<U: Display + UserInfoTrait> AuthenticatorTrait<U> for CustomAuthenticator {
        async fn authenticate(info: UserLoginInfo) -> U {
            if info.username == "abc" && info.password == "123" {
                println!("OK")
            } else {
                println!("ERROR")
            }
            // UserInfo{token:None,user_id:0}
            U::new(Some(0), None)
        }
    }

    impl<U: Display + UserInfoTrait> AuthenticatorTraitSync<U> for CustomAuthenticator {
        fn authenticate(info: UserLoginInfo) -> U {
            if info.username == "abc" && info.password == "123" {
                println!("OK")
            } else {
                println!("ERROR")
            }

            U::new(Some(0), None)
        }
    }

    #[async_trait::async_trait]
    impl AuthorizerTrait for CustomAuthorizer {
        async fn authorize(uid: i64, resource: String) -> bool {
            if uid == 1 && resource == "/a/b/c" {
                return true;
            }
            false
        }
    }

    impl AuthorizerTraitSync for CustomAuthorizer {
        fn authorize(uid: i64, resource: String) -> bool {
            if uid == 1 && resource == "/a/b/c" {
                return true;
            }
            false
        }
    }

    #[tokio::test]
    async fn test_auth() {
        let auth = Auth::<_, _, UserInfo> {
            authenticator: CustomAuthenticator {},
            authorizer: CustomAuthorizer {},
            storage: Vec::new(),
        };

        auth.authenticate(UserLoginInfo {
            username: "张三".to_string(),
            password: "123".to_string(),
        })
        .await;

        let r = auth.authorize(1, "/a/b/c".to_string()).await;

        println!("result: {}", r);

        let r = auth.authorize_sync(2, "/a/b/c".to_string());

        println!("result: {}", r);
    }
}
