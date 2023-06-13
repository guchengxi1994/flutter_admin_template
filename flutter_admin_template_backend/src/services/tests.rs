mod tests {
    #[test]
    pub fn new_user_test() {
        {
            let url = format!(
                "mysql://{}:{}@{}:{}/{}",
                "root", "123456", "localhost", "3306", "flutter_admin_template"
            );
            let rt = tokio::runtime::Runtime::new().unwrap();
            rt.block_on(async {
                crate::database::init::init(url).await;
            })
        }
        {
            let req = crate::services::user_service::NewUserRequest {
                dept_id: None,
                user_name: "admin".to_string(),
                password: "123456".to_string(),
                create_by: None,
                remark: Some("this is admin".to_string()),
            };
            let rt = tokio::runtime::Runtime::new().unwrap();
            rt.block_on(async {
                let r = crate::models::user::User::new_user(req).await;
                match r {
                    Ok(_) => {
                        println!("OK")
                    }
                    Err(e) => {
                        println!("[rust error] : {:?}", e)
                    }
                }
            })
        }
    }
}
