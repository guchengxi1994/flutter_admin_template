use sqlx::types::chrono;

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Router {
    pub router_id: i64,
    pub router_name: String,
    pub router: String,
    pub create_by: Option<i64>,
    pub create_time: chrono::DateTime<chrono::Local>,
    pub update_time: chrono::DateTime<chrono::Local>,
    pub is_deleted: i64,
    pub remark: Option<String>,
    pub parent_id: i64,
}
