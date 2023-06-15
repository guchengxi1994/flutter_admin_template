use crate::constants::TOKEN_EXPIRE;

pub fn refresh_token(s: String, con: &mut redis::Connection) -> anyhow::Result<()> {
    let d = TOKEN_EXPIRE.lock().unwrap();
    let _: () = redis::Commands::expire(con, s, *d)?;
    anyhow::Ok(())
}
