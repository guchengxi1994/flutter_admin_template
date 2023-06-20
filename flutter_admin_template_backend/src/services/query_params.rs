use std::fmt::Display;

#[derive(Debug, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ByIdMany {
    pub page_number: i64,
    pub page_size: i64,
    pub user_id : i64,
}

impl Display for ByIdMany {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "page_number : {:?}, page_size: {:?}, user_id:{:?}",
            self.page_number, self.page_size,self.user_id
        )
    }
}

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
pub struct DataList<T> {
    pub count: i64,
    pub records: Vec<T>,
}

#[derive(Clone, Debug, sqlx::FromRow)]
pub struct Count {
    pub count: i64,
}

pub struct QueryParam<T>
where
    T: Display,
{
    pub data: T,
}

#[derive(Debug, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Pagination {
    pub page_number: i64,
    pub page_size: i64,
}

impl Display for Pagination {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "page_number : {:?}, page_size: {:?}",
            self.page_number, self.page_size
        )
    }
}