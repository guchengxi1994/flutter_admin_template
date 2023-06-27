pub mod auth;
pub mod refresh_token;
pub mod reject_request;
use crate::constants::REJECT_DURATION;

#[derive(Clone)]
pub struct UserId {
    pub user_id: i64,
}

fn get_reject_times(s: String, con: &mut redis::Connection) -> anyhow::Result<i32> {
    let i: i32 = redis::Commands::get(con, s)?;
    anyhow::Ok(i)
}

fn times_add_one(s: String, con: &mut redis::Connection) -> anyhow::Result<()> {
    let i = get_reject_times(s.clone(), con)?;
    let _: () = redis::Commands::set(con, s.clone(), i + 1)?;
    let _: () = redis::Commands::expire(con, s, REJECT_DURATION)?;
    anyhow::Ok(())
}

fn set_first_time(s: String, con: &mut redis::Connection) -> anyhow::Result<()>{
    let _: () = redis::Commands::set(con, s.clone(), 1)?;
    let _: () = redis::Commands::expire(con, s, REJECT_DURATION)?;
    anyhow::Ok(())
}
