use std::{
    collections::HashMap,
    sync::{Mutex, RwLock},
};

use lazy_static::lazy_static;

lazy_static! {
    pub static ref TOKEN_EXPIRE: Mutex<usize> = Mutex::new(3600);
    pub static ref REJECT_TIMES: Mutex<i32> = Mutex::new(3);
    pub static ref REJECT_DURATION: Mutex<usize> = Mutex::new(10);
    // api_router 和 api_id 的对应
    pub static ref API_ID_MAP: RwLock<HashMap<String, i64>> = RwLock::new(HashMap::new());
}

pub const BAD_REQUEST: i32 = 20001;
pub const INVALID_USER: i32 = 40001;
pub const INVALID_TOKEN: i32 = 40002;
pub const OK: i32 = 20000;
pub const NO_AUTH: i32 = 20002;
pub const WS_CONNECTION_ERR: i32 = 20003;
