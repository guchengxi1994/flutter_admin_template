mod tests {
    use gm_sm3::sm3_hash;
    #[test]
    fn sm3_test() {
        let hash = sm3_hash(b"123456");
        let r = hex::encode(hash.as_ref());
        println!("{:?}", r);
    }

    use std::fmt::Display;

    use fat_auth::user_service::{
        auth::{
            Auth, AuthenticatorTrait, AuthenticatorTraitSync, AuthorizerTrait, AuthorizerTraitSync,
        },
        user_info::{UserInfo, UserInfoTrait},
    };

    pub struct CustomAuthenticator;

    pub struct CustomAuthorizer;

    #[async_trait::async_trait]
    impl<U: Display + UserInfoTrait> AuthenticatorTrait<U> for CustomAuthenticator {
        async fn authenticate(username: String, password: String) -> anyhow::Result<U> {
            if username == "abc" && password == "123" {
                println!("OK")
            } else {
                println!("ERROR")
            }
            // UserInfo{token:None,user_id:0}
            anyhow::Ok(U::new(Some(0), None))
        }
    }

    impl<U: Display + UserInfoTrait> AuthenticatorTraitSync<U> for CustomAuthenticator {
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

        let _ = auth.authenticate("张三".to_string(), "123".to_string())
            .await;

        let r = auth.authorize(1, "/a/b/c".to_string()).await;

        println!("result: {}", r);

        let r = auth.authorize_sync(2, "/a/b/c".to_string());

        println!("result: {}", r);
    }
}
