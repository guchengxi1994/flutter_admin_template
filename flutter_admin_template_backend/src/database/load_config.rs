use serde::{Deserialize, Serialize};
use std::fs::File;
use std::io::Read;

#[derive(Serialize, Deserialize, Debug)]
pub struct DatabaseInfo {
    pub name: String,
    pub address: String,
    pub port: String,
    pub username: String,
    pub password: String,
    pub database: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RedisInfo {
    pub hostname: String,
    pub port: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Config {
    pub title: String,
    pub database: DatabaseInfo,
    pub redis: RedisInfo,
    pub middleware: Middleware,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Middleware {
    pub reject_times: i32,
    pub reject_duration: usize,
}

pub fn load_config(conf_path: &str) -> Option<Config> {
    let file_path = conf_path;
    let mut file: File = match File::open(file_path) {
        Ok(f) => f,
        Err(_) => {
            println!("[rust error] can not load db_config file");
            return None;
        }
    };

    let mut str_val = String::new();
    match file.read_to_string(&mut str_val) {
        Ok(s) => s,
        Err(_) => {
            println!("can not load db info");
            return None;
        }
    };

    let p: Config = toml::from_str(&str_val).unwrap();
    Some(p)
}
