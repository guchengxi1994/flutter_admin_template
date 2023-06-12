use std::sync::{Arc, RwLock};

use lazy_static::lazy_static;
use sqlx::{MySql, MySqlPool, Pool};

/// 自定义连接池结构体
pub struct MyPool(Option<Pool<MySql>>);

impl MyPool {
    /// 创建连接池
    async fn new(uri: &str) -> Self {
        let pool = MySqlPool::connect(uri).await.unwrap();
        MyPool(Some(pool))
    }

    /// 获取连接池
    pub fn get_pool(&self) -> &Pool<MySql> {
        self.0.as_ref().unwrap()
    }
}

/// 实现 Default trait
impl Default for MyPool {
    fn default() -> Self {
        MyPool(None)
    }
}

// 声明创建静态连接池
lazy_static! {
    pub static ref POOL: Arc<RwLock<MyPool>> = Arc::new(RwLock::new(Default::default()));
}

pub fn init_database_from_config_file(conf_path: &str) {
    let option = crate::database::load_config::load_config(conf_path);
    match option {
        Some(o) => {
            let url = format!(
                "mysql://{}:{}@{}:{}/{}",
                o.database.username,
                o.database.password,
                o.database.address,
                o.database.port,
                o.database.database
            );
            init(url);
        }
        None => {
            println!("[rust error] : load config file error")
        }
    }
}

pub fn init(url: String) {
    let rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async {
        let pool = POOL.clone();
        let pool = pool.write();
        match pool {
            Ok(mut p) => {
                *p = MyPool::new(&url).await;
                println!("[rust] : db init");
            }
            Err(e) => {
                println!("[rust error] : {:?}", e);
            }
        }
    })
}
