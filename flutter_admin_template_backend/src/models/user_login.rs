use sqlx::types::chrono;

#[derive(Clone, Debug, sqlx::FromRow)]
pub struct UserLogin {
    pub login_id: i64,
    pub user_id: i64,
    pub login_ip: String,
    pub login_date: chrono::DateTime<chrono::Utc>,
}
