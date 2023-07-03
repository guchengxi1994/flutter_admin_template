use std::sync::Mutex;

use lazy_static::lazy_static;

lazy_static! {
    pub static ref TOKEN_EXPIRE: Mutex<usize> = Mutex::new(3600);

    pub static ref REJECT_TIMES:Mutex<i32> = Mutex::new(3);

    pub static ref REJECT_DURATION:Mutex<usize> = Mutex::new(10);
}

pub const BAD_REQUEST: i32 = 20001;
pub const INVALID_USER: i32 = 40001;
pub const INVALID_TOKEN: i32 = 40002;
pub const OK: i32 = 20000;
