use sqlx::{MySql, Pool};

use crate::models::api::Api;

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ApiSummary {
    pub api_id: i64,
    pub api_name: String,
    pub api_router: String,
    pub api_method: String,
}

#[async_trait::async_trait]
pub trait ApiTrait {
    async fn query_by_role_id(role_id: i64, pool: &Pool<MySql>) -> anyhow::Result<Vec<ApiSummary>>;

    async fn query_by_router_id(
        router_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<Vec<ApiSummary>>;

    async fn query_current(user_id: i64, pool: &Pool<MySql>) -> anyhow::Result<Vec<ApiSummary>>;

    async fn query_all(pool: &Pool<MySql>) -> anyhow::Result<Vec<Api>>;

    async fn get_api_id_by_path(s: String, pool: &Pool<MySql>) -> anyhow::Result<Option<i64>>;
}

pub struct ApiService;

#[derive(Clone, Debug, sqlx::FromRow)]
pub struct ApiId(Option<i64>);

#[async_trait::async_trait]
impl ApiTrait for ApiService {
    async fn query_by_role_id(role_id: i64, pool: &Pool<MySql>) -> anyhow::Result<Vec<ApiSummary>> {
        let sql = sqlx::query_as::<sqlx::MySql, ApiSummary>(
            r#"SELECT
        api.api_id,
        api.api_name,
        api.api_router,
        api.api_method 
    FROM
        role_api
        LEFT JOIN api ON role_api.api_id = api.api_id
        LEFT JOIN role ON role.role_id = role_api.role_id 
    WHERE
        role.is_deleted = 0 and role_api.role_id = ?"#,
        )
        .bind(role_id)
        .fetch_all(pool)
        .await?;

        anyhow::Ok(sql)
    }

    async fn query_by_router_id(
        router_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<Vec<ApiSummary>> {
        let sql;
        if router_id == -1 {
            sql = sqlx::query_as::<sqlx::MySql, ApiSummary>(
                r#"SELECT
            api.api_id,
            api.api_method,
            api.api_name,
            api.api_router 
        FROM
            router_api
            LEFT JOIN api ON router_api.api_id = api.api_id 
        WHERE
         api.is_deleted = 0 and router_api.router_id = 0"#,
            )
            .fetch_all(pool)
            .await?
        } else {
            sql = sqlx::query_as::<sqlx::MySql, ApiSummary>(
                r#"SELECT
            api.api_id,
            api.api_method,
            api.api_name,
            api.api_router 
        FROM
            router_api
            LEFT JOIN router ON router_api.router_id = router.router_id
            LEFT JOIN api ON router_api.api_id = api.api_id 
        WHERE
            router.is_deleted = 0 
            AND api.is_deleted = 0 and router_api.router_id = ?"#,
            )
            .bind(router_id)
            .fetch_all(pool)
            .await?
        }

        anyhow::Ok(sql)
    }

    async fn query_current(user_id: i64, pool: &Pool<MySql>) -> anyhow::Result<Vec<ApiSummary>> {
        let sql = sqlx::query_as::<sqlx::MySql, ApiSummary>(
            r#"SELECT
            api.api_id,
            api.api_name,
            api.api_router,
            api.api_method 
        FROM
            user_role
            LEFT JOIN role_api ON user_role.role_id = role_api.role_id
            LEFT JOIN api ON role_api.api_id = api.api_id 
        WHERE
            `user_role`.user_id = ? and api.is_deleted = 0 order by api_id"#,
        )
        .bind(user_id)
        .fetch_all(pool)
        .await?;

        anyhow::Ok(sql)
    }

    async fn query_all(pool: &Pool<MySql>) -> anyhow::Result<Vec<Api>> {
        let sql = sqlx::query_as::<sqlx::MySql, Api>(r#"select * from api where is_deleted = 0"#)
            .fetch_all(pool)
            .await?;

        anyhow::Ok(sql)
    }

    async fn get_api_id_by_path(s: String, pool: &Pool<MySql>) -> anyhow::Result<Option<i64>> {
        let sql = sqlx::query_as::<sqlx::MySql, ApiId>(
            r#"select api_id from api where is_deleted = 0 and api_router = ?"#,
        )
        .bind(s)
        .fetch_one(pool)
        .await?;

        anyhow::Ok(sql.0)
    }
}
