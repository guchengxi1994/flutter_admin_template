use super::init::REDIS_CLIENT;

pub fn validate_token(s: String) -> anyhow::Result<i64> {
    let mut con = REDIS_CLIENT.lock().unwrap().clone().unwrap();
    let r: i64 = redis::Commands::get(&mut con, s)?;
    anyhow::Ok(r)
}
