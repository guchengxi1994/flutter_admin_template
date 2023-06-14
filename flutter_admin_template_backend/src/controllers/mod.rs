pub mod user_controller;
pub mod user_login_controller;


#[derive(Debug, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Pagination{
    pub page_number : i64,
    pub page_size : i64,
}
