use super::init::REDIS_CLIENT_SYNC;

pub fn validate_token(s: String) -> anyhow::Result<i64> {
    let mut con = REDIS_CLIENT_SYNC.lock().unwrap().clone().unwrap();
    let r: i64 = redis::Commands::get(&mut con, s)?;
    anyhow::Ok(r)
}
