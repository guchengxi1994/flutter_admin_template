use crate::constants::API_ID_MAP;

use super::init::REDIS_CLIENT;

#[derive(Clone, Debug, sqlx::FromRow)]
pub struct ApiIdMap {
    pub api_id: i64,
    pub api_router: String,
}

pub async fn init_api() -> anyhow::Result<()> {
    let pool = crate::database::init::POOL.lock().unwrap();

    let r = sqlx::query_as::<sqlx::MySql, ApiIdMap>(
        r#"select api_id,api_router from api where is_deleted = 0"#,
    )
    .fetch_all(pool.get_pool())
    .await?;

    {
        let mut m = API_ID_MAP.write().unwrap();
        for i in r {
            m.insert(i.api_router, i.api_id);
        }
    }

    println!("{:?}", API_ID_MAP.read().unwrap());

    anyhow::Ok(())
}

pub fn can_api_be_visited(api_router: String, token: String) -> bool {
    let reserved: Vec<i64> = Vec::from([12, 13, 9, 5, 16]);
    let m = API_ID_MAP.read().unwrap();
    let id = m.get(&api_router);

    if let Some(i) = id {
        if reserved.contains(i) {
            return true;
        }
    }

    let api_key = format!("{}_apis", token);
    let cli = REDIS_CLIENT.lock().unwrap().clone().unwrap();
    let mut con = cli.get_connection().unwrap();
    let api_ids: Vec<i64> = redis::Commands::lrange(&mut con, api_key, 0, -1).unwrap();

    if let Some(i) = id {
        if api_ids.contains(i) {
            return true;
        }
    }

    false
}
