use self::query_params::{
    ByIdMany, Count, DataList, Pagination, QueryParam, SigninRecordsQueryParam,
};
use sqlx::{MySql, Pool};

pub mod log_service;
pub mod query_params;
pub mod router_service;
mod tests;
pub mod user_service;
pub mod role_service;
pub mod api_service;
pub mod department_service;

#[async_trait::async_trait]
pub trait Query<T> {
    async fn all(
        pool: &Pool<MySql>,
        query_params: QueryParam<SigninRecordsQueryParam>,
    ) -> anyhow::Result<DataList<T>>;

    async fn by_id_single(id: i64, pool: &Pool<MySql>) -> anyhow::Result<T>;

    async fn by_id_many(
        pool: &Pool<MySql>,
        query_params: QueryParam<ByIdMany>,
    ) -> anyhow::Result<DataList<T>>;

    async fn current_single(id: i64, pool: &Pool<MySql>) -> anyhow::Result<T>;

    async fn current_many(
        id: i64,
        pool: &Pool<MySql>,
        query_params: QueryParam<Pagination>,
    ) -> anyhow::Result<DataList<T>>;
}
