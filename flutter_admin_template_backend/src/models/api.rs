use sqlx::types::chrono;

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Api {
    pub api_id: i64,
    pub api_name: String,
    pub api_router: String,
    pub api_method: String,
    pub create_time: chrono::DateTime<chrono::Local>,
    pub update_time: chrono::DateTime<chrono::Local>,
    pub is_deleted: i64,
    pub remark: Option<String>,
}
