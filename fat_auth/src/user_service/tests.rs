mod tests {
    use crate::user_service::{
        auth::{
            Auth, AuthenticatorTrait, AuthenticatorTraitSync, AuthorizerTrait, AuthorizerTraitSync,
        },
        user_info::UserLoginInfo,
    };

    pub struct CustomAuthenticator;

    pub struct CustomAuthorizer;

    #[async_trait::async_trait]
    impl AuthenticatorTrait for CustomAuthenticator {
        async fn authenticate(info: UserLoginInfo) {
            if info.username == "abc" && info.password == "123" {
                println!("OK")
            } else {
                println!("ERROR")
            }
        }
    }

    impl AuthenticatorTraitSync for CustomAuthenticator {
        fn authenticate(info: UserLoginInfo) {
            if info.username == "abc" && info.password == "123" {
                println!("OK")
            } else {
                println!("ERROR")
            }
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
        let auth = Auth {
            authenticator: CustomAuthenticator {},
            authorizer: CustomAuthorizer {},
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
