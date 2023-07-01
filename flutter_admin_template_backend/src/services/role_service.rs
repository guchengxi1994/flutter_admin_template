use sqlx::{Pool, MySql};

use crate::models::role::Role;

#[async_trait::async_trait]
pub trait RoleTrait {
    async fn query_all(pool: &Pool<MySql>)->anyhow::Result<Vec<Role>>;
}

pub struct RoleService;

#[async_trait::async_trait]
impl RoleTrait for RoleService {
    async fn query_all(pool: &Pool<MySql>)->anyhow::Result<Vec<Role>>{
        let r = sqlx::query_as::<sqlx::MySql,Role>(r#"select * from role where is_deleted = 0"#).fetch_all(pool).await?;

        anyhow::Ok(r)
    }
}