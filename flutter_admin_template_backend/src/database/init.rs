use std::sync::Mutex;

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
    pub static ref POOL: Mutex<MyPool> = Mutex::new(Default::default());
    pub static ref REDIS_CLIENT: Mutex<Option<redis::Client>> = Mutex::new(None);
}

pub async fn init_database_from_config_file(conf_path: &str) {
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
            let redis_url = format!("redis://{}:{}/", o.redis.hostname, o.redis.port);
            init(url).await;
            let _ = init_redis(redis_url);
        }
        None => {
            println!("[rust error] : load config file error");
            panic!("load config file error")
        }
    }
}

pub fn init_redis(url: String) -> anyhow::Result<()> {
    let client = redis::Client::open(url)?;
    let mut c = REDIS_CLIENT.lock().unwrap();
    *c = Some(client);
    anyhow::Ok(())
}

pub async fn init(url: String) {
    let mut pool = POOL.lock().unwrap();
    *pool = MyPool::new(&url).await
}
