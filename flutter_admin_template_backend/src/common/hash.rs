use std::time::{SystemTime, UNIX_EPOCH};

use gm_sm3::sm3_hash;

pub fn get_token(p: String) -> String {
    let r = get_current_unix().to_string();
    r.to_string().push_str(&p);
    let hash = sm3_hash(r.as_bytes());
    let r = hex::encode(hash.as_ref());
    return r;
}

fn get_current_unix() -> u64 {
    let s = SystemTime::now().duration_since(UNIX_EPOCH);
    match s {
        Ok(_s) => {
            return _s.as_secs();
        }
        Err(_) => {
            return 0;
        }
    }
}
