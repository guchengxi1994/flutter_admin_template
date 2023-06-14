use sqlx::{Pool, MySql};

mod tests;
pub mod user_login_service;
pub mod user_service;

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
pub struct DataList<T>{
    pub count :i64,
    pub data : Vec<T>
}

#[derive(Clone, Debug, sqlx::FromRow)]
struct Count{
    pub count : i64
}

#[async_trait::async_trait]
pub trait Query<T> {
    async fn all(pool:&Pool<MySql>,page_size:i64,page_number:i64) -> anyhow::Result<DataList<T>>;

    async fn by_id_single(id: i64,pool:&Pool<MySql>) -> anyhow::Result<T>;

    async fn by_id_many(id: i64,pool:&Pool<MySql>,page_size:i64,page_number:i64) -> anyhow::Result<DataList<T>>;
}
