use sqlx::{MySql, Pool};

use crate::models::role::Role;

use super::router_service::RouterSummary;

#[async_trait::async_trait]
pub trait RoleTrait {
    async fn query_all(pool: &Pool<MySql>) -> anyhow::Result<Vec<Role>>;

    async fn query_details_by_id(role_id: i64, pool: &Pool<MySql>) -> anyhow::Result<RoleDetails>;

    async fn get_current_role_details(
        user_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<RoleDetails>;

    async fn get_role_id_by_user_id(
        user_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<Option<i64>>;

    async fn update_role(
        role_id: i64,
        routers: Vec<i64>,
        apis: Vec<i64>,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<()>;
}

pub struct RoleService;

#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct RoleDetails {
    pub router_ids: Vec<i64>,
    pub all_routers: Vec<RouterSummary>,
}

#[derive(Clone, Debug, sqlx::FromRow)]
pub struct CurrentRouterIds(i64);

#[derive(Clone, Debug, sqlx::FromRow)]
pub struct RoleId(Option<i64>);

#[async_trait::async_trait]
impl RoleTrait for RoleService {
    async fn query_all(pool: &Pool<MySql>) -> anyhow::Result<Vec<Role>> {
        let r = sqlx::query_as::<sqlx::MySql, Role>(r#"select * from role where is_deleted = 0"#)
            .fetch_all(pool)
            .await?;

        anyhow::Ok(r)
    }

    async fn get_current_role_details(
        user_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<RoleDetails> {
        let r = sqlx::query_as::<sqlx::MySql, RouterSummary>(
            r#"select router_id,router_name,router,parent_id from router where is_deleted=0"#,
        )
        .fetch_all(pool)
        .await?;

        let r2 = sqlx::query_as::<sqlx::MySql,CurrentRouterIds>(r#"select router_id from user_role left join role on user_role.role_id= role.role_id LEFT JOIN role_router on user_role.role_id = role_router.role_id WHERE user_role.user_id = ? and role.is_deleted = 0 order by router_id"#).bind(user_id).fetch_all(pool).await?;

        let mut v: Vec<i64> = Vec::new();
        for i in r2 {
            v.push(i.0);
        }

        anyhow::Ok(RoleDetails {
            router_ids: v,
            all_routers: r,
        })
    }

    async fn query_details_by_id(role_id: i64, pool: &Pool<MySql>) -> anyhow::Result<RoleDetails> {
        let r = sqlx::query_as::<sqlx::MySql, RouterSummary>(
            r#"select router_id,router_name,router,parent_id from router where is_deleted=0"#,
        )
        .fetch_all(pool)
        .await?;

        let r2 = sqlx::query_as::<sqlx::MySql,CurrentRouterIds>(r#"select router_id from role_router left join role on role.role_id = role_router.role_id WHERE role.role_id = ? and role.is_deleted = 0"#).bind(role_id).fetch_all(pool).await?;

        let mut v: Vec<i64> = Vec::new();
        for i in r2 {
            v.push(i.0);
        }

        anyhow::Ok(RoleDetails {
            router_ids: v,
            all_routers: r,
        })
    }

    async fn get_role_id_by_user_id(
        user_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<Option<i64>> {
        let r = sqlx::query_as::<sqlx::MySql, RoleId>(
            r#"select role_id from user_role WHERE user_id = ?"#,
        )
        .bind(user_id)
        .fetch_one(pool)
        .await?;

        anyhow::Ok(r.0)
    }

    async fn update_role(
        role_id: i64,
        routers: Vec<i64>,
        apis: Vec<i64>,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<()> {
        let mut tx = pool.begin().await?;
        let _ = sqlx::query(r#"delete from role_api where role_id = ?"#)
            .bind(role_id)
            .execute(&mut tx)
            .await?;
        if apis.len() > 0 {
            let mut quary =
                sqlx::QueryBuilder::<MySql>::new("insert into role_api (role_id,api_id) values");

            for i in 0..apis.len() {
                quary.push("(");
                quary.push_bind(role_id);
                quary.push(",");
                quary.push_bind(apis[i]);
                quary.push(")");
                if i != apis.len() - 1 {
                    quary.push(",");
                }
            }

            let _ = quary.build().execute(&mut tx).await?;
        }

        let _ = sqlx::query(r#"delete from role_router where role_id = ?"#)
            .bind(role_id)
            .execute(&mut tx)
            .await?;

        if routers.len() > 0 {
            let mut quary = sqlx::QueryBuilder::<MySql>::new(
                "insert into role_router (role_id,router_id) values",
            );

            for i in 0..routers.len() {
                quary.push("(");
                quary.push_bind(role_id);
                quary.push(",");
                quary.push_bind(routers[i]);
                quary.push(")");
                if i != routers.len() - 1 {
                    quary.push(",");
                }
            }

            let _ = quary.build().execute(&mut tx).await?;
        }

        tx.commit().await?;

        anyhow::Ok(())
    }
}
