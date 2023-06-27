use std::sync::Mutex;

use lazy_static::lazy_static;

lazy_static! {
    pub static ref TOKEN_EXPIRE: Mutex<usize> = Mutex::new(3600);
}

pub const REJECT_TIMES:i32 = 3;
// 10 sec
pub const REJECT_DURATION:usize = 10;

pub const BAD_REQUEST: i32 = 20001;
pub const INVALID_USER: i32 = 40001;
pub const INVALID_TOKEN: i32 = 40002;
pub const OK: i32 = 20000;
