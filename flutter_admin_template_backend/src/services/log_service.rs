use sqlx::{MySql, Pool, QueryBuilder};

use crate::models::sign_in_record::{SignInRecord};

use super::{
    query_params::SigninRecordsQueryParam,
    query_params::{ByIdMany, Count},
    Pagination, QueryParam,
};

#[async_trait::async_trait]
impl super::Query<SignInRecord> for SignInRecord {
    async fn all(
        pool: &Pool<MySql>,
        query_params: QueryParam<SigninRecordsQueryParam>,
    ) -> anyhow::Result<super::DataList<Self>> {
        let _q = query_params.data;

        let mut query = QueryBuilder::<MySql>::new("SELECT * FROM user_login WHERE user_id>0");
        let mut count_query = QueryBuilder::<MySql>::new(
            "SELECT COUNT(login_id) as count FROM ( SELECT * FROM user_login WHERE user_id>0",
        );
        if let Some(username) = _q.username {
            query.push(" and user_name LIKE ");
            let l = format!("'%{}%'", username);
            query.push(l.clone());
            count_query.push(" and user_name LIKE ");
            count_query.push(l);
        }

        if let Some(state) = _q.state {
            if state == "success" {
                query.push(" and login_state = 'success'");
                count_query.push(" and login_state = 'success'");
            } else {
                query.push(" and login_state != 'success'");
                count_query.push(" and login_state != 'success'");
            }
        }

        if let Some(user_id) = _q.user_id {
            query.push(" and user_id = ");
            query.push_bind(user_id);

            count_query.push(" and user_id = ");
            count_query.push_bind(user_id);
        }

        if let Some(start_time) = _q.start_time {
            if let Some(end_time) = _q.end_time {
                query.push(" and UNIX_TIMESTAMP(login_time) > ");
                query.push_bind(start_time);
                query.push(" and UNIX_TIMESTAMP(login_time) < ");
                query.push_bind(end_time);

                count_query.push(" and UNIX_TIMESTAMP(login_time) > ");
                count_query.push_bind(start_time);
                count_query.push(" and UNIX_TIMESTAMP(login_time) < ");
                count_query.push_bind(end_time);
            }
        }

        count_query.push(" ) as t");

        let count: Count = count_query.build_query_as().fetch_one(pool).await?;

        query.push(" limit");
        query.push_bind((_q.page_number - 1) * _q.page_size);
        query.push(",");
        query.push_bind(_q.page_size);

        let logs: Vec<SignInRecord> = query.build_query_as().fetch_all(pool).await?;
        anyhow::Ok(super::DataList {
            count: count.count,
            records: logs,
        })
    }

    async fn current_single(id: i64, pool: &Pool<MySql>) -> anyhow::Result<Self> {
        let log = sqlx::query_as::<sqlx::MySql, SignInRecord>(
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

        let logs: Vec<SignInRecord> = query.build_query_as().fetch_all(pool).await?;

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
        let log = sqlx::query_as::<sqlx::MySql, SignInRecord>(
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

        let logs: Vec<SignInRecord> = query.build_query_as().fetch_all(pool).await?;

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

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct SignInSummary {
    pub count: i64,
    pub login_state: String,
}

pub async fn get_sign_in_log_summary(
    pool: &Pool<MySql>,
    user_id: i64,
) -> anyhow::Result<Vec<SignInSummary>> {
    let mut query: QueryBuilder<'_, _>;
    if user_id != 1 {
        query = QueryBuilder::new("SELECT count(login_id) as count,login_state FROM user_login LEFT JOIN `user` ON user_login.user_id = `user`.user_id WHERE `user`.is_deleted = 0  and `user`.user_id = ");
        query.push_bind(user_id);
    } else {
        query = QueryBuilder::new("SELECT count(login_id) as count,login_state FROM user_login LEFT JOIN `user` ON user_login.user_id = `user`.user_id WHERE `user`.is_deleted = 0  and `user`.user_id > 0 ")
    }

    query.push(" GROUP BY user_login.login_state");
    let result: Vec<SignInSummary> = query.build_query_as().fetch_all(pool).await?;

    anyhow::Ok(result)
}
