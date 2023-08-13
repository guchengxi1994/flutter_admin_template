use sqlx::types::chrono;

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Role {
    pub role_id: i64,
    pub role_name: String,
    #[serde(skip)]
    pub create_by: Option<String>,
    pub create_time: chrono::DateTime<chrono::Local>,
    pub update_time: chrono::DateTime<chrono::Local>,
    #[serde(skip)]
    pub is_deleted: i64,
    pub remark: Option<String>,
}
