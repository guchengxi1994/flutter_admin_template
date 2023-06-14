use sqlx::{MySql, Pool};

use crate::models::user_login::UserLogin;

#[async_trait::async_trait]
impl super::Query<UserLogin> for UserLogin {
    async fn all(
        pool: &Pool<MySql>,
        page_size: i64,
        page_number: i64,
    ) -> anyhow::Result<super::DataList<Self>> {
        let logs =
            sqlx::query_as::<sqlx::MySql, UserLogin>(r#"SELECT * FROM user_login limit ?,?"#)
                .bind((page_number - 1) * page_size)
                .bind(page_size)
                .fetch_all(pool)
                .await?;
        let count = sqlx::query_as::<sqlx::MySql, super::Count>(
            r#"SELECT COUNT(login_id) as count FROM user_login"#,
        )
        .fetch_one(pool)
        .await?;
        anyhow::Ok(super::DataList {
            count: count.count,
            data: logs,
        })
    }

    async fn by_id_single(id: i64, pool: &Pool<MySql>) -> anyhow::Result<Self> {
        let log = sqlx::query_as::<sqlx::MySql, UserLogin>(
            r#"SELECT * FROM user_login WHERE user_id = ? order by login_id desc limit 1"#,
        )
        .bind(id)
        .fetch_one(pool)
        .await?;
        anyhow::Ok(log)
    }

    async fn by_id_many(
        id: i64,
        pool: &Pool<MySql>,
        page_size: i64,
        page_number: i64,
    ) -> anyhow::Result<super::DataList<Self>> {
        let logs = sqlx::query_as::<sqlx::MySql, UserLogin>(
            r#"SELECT * FROM user_login WHERE user_id = ? order by login_id desc limit ?,?"#,
        )
        .bind(id)
        .bind((page_number - 1) * page_size)
        .bind(page_size)
        .fetch_all(pool)
        .await?;
        // anyhow::Ok(log)
        let count = sqlx::query_as::<sqlx::MySql, super::Count>(
            r#"SELECT COUNT(login_id) as count FROM user_login WHERE user_id = ?"#,
        )
        .bind(id)
        .fetch_one(pool)
        .await?;
        anyhow::Ok(super::DataList {
            count: count.count,
            data: logs,
        })
    }
}
