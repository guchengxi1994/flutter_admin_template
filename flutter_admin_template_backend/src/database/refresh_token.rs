pub fn refresh_token(s: String, con: &mut redis::Connection) -> anyhow::Result<()> {
    let _: () = redis::Commands::expire(con, s, 300)?;
    anyhow::Ok(())
}
