use sqlx::{MySql, Pool};

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

    async fn query_current(user_id: i64, pool: &Pool<MySql>);

    async fn query_all(pool: &Pool<MySql>);
}

pub struct ApiService;

#[async_trait::async_trait]
impl ApiTrait for ApiService {
    async fn query_by_role_id(role_id: i64, pool: &Pool<MySql>) -> anyhow::Result<Vec<ApiSummary>> {
        todo!()
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

    async fn query_current(user_id: i64, pool: &Pool<MySql>) {
        todo!()
    }

    async fn query_all(pool: &Pool<MySql>) {
        todo!()
    }
}
