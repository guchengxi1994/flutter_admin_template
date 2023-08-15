use sqlx::types::chrono;

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct SysDict {
    pub dict_id: i64,
    pub dict_name: String,
    pub dict_type: String,
    pub create_time: chrono::DateTime<chrono::Local>,
    pub update_time: chrono::DateTime<chrono::Local>,
    #[serde(skip)]
    pub is_deleted: i64,
    pub remark: Option<String>,
}

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
pub struct SysDictData {
    pub dict_data_id: i64,
    pub dict_label: String,
    pub dict_id: i64,
    pub create_time: chrono::DateTime<chrono::Local>,
    pub update_time: chrono::DateTime<chrono::Local>,
    pub is_deleted: i64,
    pub remark: Option<String>,
}
