#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct SysConfig {
    pub config_id: i64,
    pub config_key: String,
    pub config_value: String,
    pub create_time: chrono::DateTime<chrono::Local>,
    pub update_time: chrono::DateTime<chrono::Local>,
    #[serde(skip)]
    pub is_deleted: i64,
    pub remark: Option<String>,
}
