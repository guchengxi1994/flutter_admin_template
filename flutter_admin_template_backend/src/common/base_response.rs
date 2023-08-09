use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct BaseResponse<'a, T> {
    pub code: i32,
    pub message: &'a str,
    pub data: T,
}
