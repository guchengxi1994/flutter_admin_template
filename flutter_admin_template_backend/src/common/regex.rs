use std::sync::Mutex;

use once_cell::sync::Lazy;
use regex::Regex;

pub static SYS_DICT_REGEX: Lazy<Mutex<Regex>> =
    Lazy::new(|| Mutex::new(Regex::new(r"sys_[a-z]+_[a-z]+").unwrap()));

pub static SYS_CONFIG_REGEX: Lazy<Mutex<Regex>> =
    Lazy::new(|| Mutex::new(Regex::new(r"sys.[a-z]+.[a-z]+").unwrap()));
