use sqlx::{MySql, Pool};

use crate::models::router::Router;

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct RouterSummary {
    pub router_id: i64,
    pub router: String,
    pub router_name: String,
    pub parent_id: i64,
}

#[async_trait::async_trait]
pub trait RouterTrait {
    async fn query_by_id(pool: &Pool<MySql>, user_id: i64) -> anyhow::Result<Vec<RouterSummary>>;

    async fn query_by_role_id(
        pool: &Pool<MySql>,
        role_id: i64,
    ) -> anyhow::Result<Vec<RouterSummary>>;

    async fn query_all(pool: &Pool<MySql>) -> anyhow::Result<Vec<Router>>;
}

pub struct RouterService;

#[async_trait::async_trait]
impl RouterTrait for RouterService {
    async fn query_by_id(pool: &Pool<MySql>, user_id: i64) -> anyhow::Result<Vec<RouterSummary>> {
        let routers = sqlx::query_as::<sqlx::MySql, RouterSummary>(r#"select router.router_id,router.router,router.router_name,router.parent_id from user_role  LEFT JOIN role on `user_role`.role_id = role.role_id  LEFT JOIN role_router on role_router.role_id = role.role_id LEFT JOIN router on role_router.router_id = router.router_id WHERE role.is_deleted = 0 and router.is_deleted = 0 and `user_role`.user_id = ?"#).bind(user_id)
            .fetch_all(pool)
            .await?;

        anyhow::Ok(routers)
    }

    async fn query_by_role_id(
        pool: &Pool<MySql>,
        role_id: i64,
    ) -> anyhow::Result<Vec<RouterSummary>> {
        let routers = sqlx::query_as::<sqlx::MySql, RouterSummary>(r#"select router.router_id,router.router,router.router_name,router.parent_id from role_router LEFT JOIN router on role_router.router_id = router.router_id WHERE router.is_deleted = 0  and `role_router`.role_id = ?"#).bind(role_id)
            .fetch_all(pool)
            .await?;

        anyhow::Ok(routers)
    }

    async fn query_all(pool: &Pool<MySql>) -> anyhow::Result<Vec<Router>> {
        let result = sqlx::query_as::<sqlx::MySql, Router>(
            r#"select * from router where is_deleted = 0 order by parent_id"#,
        )
        .fetch_all(pool)
        .await?;

        anyhow::Ok(result)
    }
}
