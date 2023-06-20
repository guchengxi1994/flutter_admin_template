use sqlx::{MySql, Pool, QueryBuilder};

use crate::models::user_login::UserLogin;

use super::{Pagination, QueryParam, query_params::ByIdMany};



#[async_trait::async_trait]
impl super::Query<UserLogin> for UserLogin {
    async fn all(
        pool: &Pool<MySql>,
        query_params: QueryParam<Pagination>,
    ) -> anyhow::Result<super::DataList<Self>> {
        let _q = query_params.data;
        let logs =
            sqlx::query_as::<sqlx::MySql, UserLogin>(r#"SELECT * FROM user_login limit ?,?"#)
                .bind((_q.page_number - 1) * _q.page_size)
                .bind(_q.page_size)
                .fetch_all(pool)
                .await?;
        let count = sqlx::query_as::<sqlx::MySql, super::Count>(
            r#"SELECT COUNT(login_id) as count FROM user_login"#,
        )
        .fetch_one(pool)
        .await?;
        anyhow::Ok(super::DataList {
            count: count.count,
            records: logs,
        })
    }

    async fn current_single(id: i64, pool: &Pool<MySql>) -> anyhow::Result<Self> {
        let log = sqlx::query_as::<sqlx::MySql, UserLogin>(
            r#"SELECT * FROM user_login WHERE user_id = ? order by login_id desc limit 1"#,
        )
        .bind(id)
        .fetch_one(pool)
        .await?;
        anyhow::Ok(log)
    }

    async fn current_many(
        id: i64,
        pool: &Pool<MySql>,
        query_params: QueryParam<Pagination>,
    ) -> anyhow::Result<super::DataList<Self>> {
        let _q = query_params.data;
        let mut query = QueryBuilder::new("SELECT * FROM user_login WHERE user_id = ");
        query.push_bind(id);

        query.push(" order by login_id desc limit ");

        query.push_bind((_q.page_number - 1) * _q.page_size);
        query.push(",");
        query.push_bind(_q.page_size);

        let logs: Vec<UserLogin> = query.build_query_as().fetch_all(pool).await?;

        let count = sqlx::query_as::<sqlx::MySql, super::Count>(
            r#"SELECT COUNT(login_id) as count FROM user_login WHERE user_id = ?"#,
        )
        .bind(id)
        .fetch_one(pool)
        .await?;
        anyhow::Ok(super::DataList {
            count: count.count,
            records: logs,
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
        pool: &Pool<MySql>,
        query_params: QueryParam<ByIdMany>,
    ) -> anyhow::Result<super::DataList<Self>> {
        let _q = query_params.data;
        let mut query = QueryBuilder::new("SELECT * FROM user_login WHERE user_id = ");
        query.push_bind(_q.user_id);

        query.push(" order by login_id desc limit ");

        query.push_bind((_q.page_number - 1) * _q.page_size);
        query.push(",");
        query.push_bind(_q.page_size);

        let logs: Vec<UserLogin> = query.build_query_as().fetch_all(pool).await?;

        let count = sqlx::query_as::<sqlx::MySql, super::query_params::Count>(
            r#"SELECT COUNT(login_id) as count FROM user_login WHERE user_id = ?"#,
        )
        .bind(_q.user_id)
        .fetch_one(pool)
        .await?;
        anyhow::Ok(super::DataList {
            count: count.count,
            records: logs,
        })
    }
}
