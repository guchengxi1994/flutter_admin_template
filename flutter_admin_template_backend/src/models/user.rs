use sqlx::types::chrono;

#[derive(Clone, Debug, sqlx::FromRow)]
pub struct User {
    pub user_id: i64,
    pub dept_id: Option<i64>,
    pub user_name: String,
    pub password: String,
    pub create_by: Option<String>,
    pub create_time: chrono::DateTime<chrono::Utc>,
    pub update_time: chrono::DateTime<chrono::Utc>,
    pub is_deleted: i64,
    pub remark: Option<String>,
}
