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
                let pool = crate::database::init::POOL.lock().unwrap();
                let r = <crate::services::user_service::UserService as crate::services::user_service::UserTrait>::new_user(pool.get_pool(),req).await;
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

    #[test]
    fn get_user_test() {
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
            let rt = tokio::runtime::Runtime::new().unwrap();
            rt.block_on(async {
                let pool = crate::database::init::POOL.lock().unwrap();
                let u = sqlx::query_as::<sqlx::MySql, crate::models::user::User>(
                    r#"SELECT * from user where is_deleted = 0 and user_name = ?"#,
                )
                .bind("admin")
                .fetch_one(pool.get_pool())
                .await;
                println!("{:?}", u)
            })
        }
    }

    #[test]
    fn batch_insert_test() -> anyhow::Result<()> {
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
        let rt = tokio::runtime::Runtime::new()?;
        rt.block_on(async {
            let apis: Vec<i64> = vec![1, 2, 3, 4, 5];
            let pool = crate::database::init::POOL.lock().unwrap();
            let mut quary = sqlx::QueryBuilder::<sqlx::MySql>::new(
                "insert into role_api (role_id,api_id) values",
            );

            for i in 0..apis.len() {
                quary.push("(");
                quary.push_bind(2);
                quary.push(",");
                quary.push_bind(apis[i]);
                quary.push(")");
                if i != apis.len() - 1 {
                    quary.push(",");
                }
            }

            let _ = quary.build().execute(pool.get_pool()).await?;

            anyhow::Ok(())
        })
    }

    #[test]
    fn get_structured_depts_test() -> anyhow::Result<()> {
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
        let rt = tokio::runtime::Runtime::new()?;
        rt.block_on(async {
            let pool = crate::database::init::POOL.lock().unwrap();
            let s = <crate::services::department_service::DepartmentService as crate::services::department_service::DepartmentTrait>::query_structured_depts(pool.get_pool()).await?;
            // println!("[result]: {:?}",s);
            let j = serde_json::to_string(&s);
            println!("[result]: {}",j.unwrap());

            anyhow::Ok(())
        })
    }

    #[test]
    fn get_structured_depts_test_2() -> anyhow::Result<()> {
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
        let rt = tokio::runtime::Runtime::new()?;
        rt.block_on(async {
            let pool = crate::database::init::POOL.lock().unwrap();
            let s = <crate::services::department_service::DepartmentService as crate::services::department_service::DepartmentTrait>::query_by_parent_id(2,pool.get_pool()).await?;
            // println!("[result]: {:?}",s);
            let j = serde_json::to_string(&s);
            println!("[result]: {}",j.unwrap());

            anyhow::Ok(())
        })
    }

    #[test]
    fn create_new_dept() -> anyhow::Result<()> {
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
        let rt = tokio::runtime::Runtime::new()?;
        rt.block_on(async {
            let pool = crate::database::init::POOL.lock().unwrap();
            let req = crate::services::department_service::NewDeptRequest{ dept_name: "sub-1-1-1-1".to_string(), parent_id: 100, order_number: 1, remark: Some("".to_string()) };

            let s = <crate::services::department_service::DepartmentService as crate::services::department_service::DepartmentTrait>::create_new_dept(req,pool.get_pool()).await;
            match s {
                Ok(_) => {},
                Err(e) => {
                    println!("[rust error] :{:?}",e)
                },
            }

            anyhow::Ok(())
        })
    }

    #[test]
    fn update_dept() -> anyhow::Result<()> {
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
        let rt = tokio::runtime::Runtime::new()?;
        rt.block_on(async {
            let pool = crate::database::init::POOL.lock().unwrap();
            let req = crate::services::department_service::UpdateDeptRequest{ dept_name: "sub-1-1-1-1".to_string(), parent_id: 2, order_number: 1, remark: Some("".to_string()), dept_id: 2 };

            let s = <crate::services::department_service::DepartmentService as crate::services::department_service::DepartmentTrait>::update_dept(req,pool.get_pool()).await;
            match s {
                Ok(_) => {},
                Err(e) => {
                    println!("[rust error] :{:?}",e)
                },
            }

            anyhow::Ok(())
        })
    }

    #[test]
    fn get_tree_3() -> anyhow::Result<()> {
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
        let rt = tokio::runtime::Runtime::new()?;
        rt.block_on(async {
            let pool = crate::database::init::POOL.lock().unwrap();

            let s = <crate::services::department_service::DepartmentService as crate::services::department_service::DepartmentTrait>::get_structured_depts_without_self(2,pool.get_pool()).await;
            match s {
                Ok(_s) => {
                    let j = serde_json::to_string(&_s);
                    println!("{}",j.unwrap());
                },
                Err(e) => {
                    println!("[rust error] :{:?}",e)
                },
            }

            anyhow::Ok(())
        })
    }
}
