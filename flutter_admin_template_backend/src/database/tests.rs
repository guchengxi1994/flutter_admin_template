mod tests {
    #[test]
    pub fn init_db_test() {
        let url = format!(
            "mysql://{}:{}@{}:{}/{}",
            "root", "123456", "localhost", "3306", "knowledge_one"
        );
        {
            let rt = tokio::runtime::Runtime::new().unwrap();
            rt.block_on(async {
                crate::database::init::init(url).await;
            })
        }
        {
            let rt = tokio::runtime::Runtime::new().unwrap();
            rt.block_on(async {
                let pool = crate::database::init::POOL.lock().unwrap();
                let sql = sqlx::query(
                    r#"INSERT INTO file (file_name,file_path,file_hash) VALUES(?,?,?) "#,
                )
                .bind(Some(String::from("我的图片.png")))
                .bind(Some(String::from(
                    "C:\\Users\\xiaoshuyui\\Desktop\\我的图片.png",
                )))
                .bind("file_hash")
                .execute(pool.get_pool())
                .await;
                match sql {
                    Ok(result) => {
                        println!("{:?}", result.last_insert_id());
                    }
                    Err(err) => {
                        println!("{:?}", err);
                    }
                }
            })
        }
    }

    #[test]
    pub fn redis_test() {
        let rt = tokio::runtime::Runtime::new().unwrap();
        rt.block_on(async {
            let client = redis::Client::open("redis://127.0.0.1:6379/").unwrap();
            let mut con = client.get_connection().unwrap();
            let _: () = redis::Commands::set(&mut con, "my_key", 42).unwrap();
            let r: i64 = redis::Commands::get(&mut con, "my_key").unwrap();
            println!("[rust] : {:?}", r);
        })
    }
}
