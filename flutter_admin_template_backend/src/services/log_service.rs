use sqlx::{MySql, Pool, QueryBuilder};

use super::{
    query_params::SigninRecordsQueryParam,
    query_params::{ByIdMany, Count},
    Pagination, QueryParam,
};

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct SignInRecordWithName {
    pub login_id: i64,
    pub user_id: i64,
    pub login_ip: String,
    pub login_time: chrono::DateTime<chrono::Local>,
    pub login_state: String,
    pub user_name: String,
    #[serde(skip)]
    pub token: Option<String>,
}

#[async_trait::async_trait]
impl super::Query<SignInRecordWithName> for SignInRecordWithName {
    async fn all(
        pool: &Pool<MySql>,
        query_params: QueryParam<SigninRecordsQueryParam>,
    ) -> anyhow::Result<super::DataList<Self>> {
        let _q = query_params.data;

        let mut query = QueryBuilder::<MySql>::new("SELECT login_id,user_login.user_id,user_name,login_ip,login_time,token,login_state FROM user_login left join user on `user`.user_id = `user_login`.user_id WHERE `user`.user_id>0");
        let mut count_query = QueryBuilder::<MySql>::new(
            "SELECT COUNT(login_id) as count FROM ( SELECT login_id,user_login.user_id,user_name,login_ip,login_time,token,login_state FROM user_login left join user on `user`.user_id = `user_login`.user_id WHERE `user`.user_id>0",
        );
        if let Some(username) = _q.username {
            query.push(" and `user`.user_name LIKE ");
            let l = format!("'%{}%'", username);
            query.push(l.clone());
            count_query.push(" and `user`.user_name LIKE ");
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
            query.push(" and `user`.user_id = ");
            query.push_bind(user_id);

            count_query.push(" and `user`.user_id = ");
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

        let logs: Vec<SignInRecordWithName> = query.build_query_as().fetch_all(pool).await?;
        anyhow::Ok(super::DataList {
            count: count.count,
            records: logs,
        })
    }

    async fn current_single(id: i64, pool: &Pool<MySql>) -> anyhow::Result<Self> {
        let log = sqlx::query_as::<sqlx::MySql, SignInRecordWithName>(
            r#"SELECT login_id,user_login.user_id,user_name,login_ip,login_time,token,login_state FROM user_login left join user on `user`.user_id = `user_login`.user_id WHERE `user_login`.user_id = ? order by login_id desc limit 1"#,
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
        let mut query = QueryBuilder::new("SELECT login_id,user_login.user_id,user_name,login_ip,login_time,token,login_state FROM user_login left join `user` on `user`.user_id=user_login.user_id WHERE user_login.user_id = ");
        query.push_bind(id);

        query.push(" order by login_id desc limit ");

        query.push_bind((_q.page_number - 1) * _q.page_size);
        query.push(",");
        query.push_bind(_q.page_size);

        let logs: Vec<SignInRecordWithName> = query.build_query_as().fetch_all(pool).await?;

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
        let log = sqlx::query_as::<sqlx::MySql, SignInRecordWithName>(
            r#"SELECT login_id,user_login.user_id,user_name,login_ip,login_time,token,login_state FROM user_login left join `user` on `user`.user_id=user_login.user_id WHERE user_login.user_id = ? order by login_id desc limit 1"#,
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
        let mut query = QueryBuilder::new("SELECT login_id,user_login.user_id,user_name,login_ip,login_time,token,login_state FROM user_login left join `user` on `user`.user_id=user_login.user_id WHERE user_login.user_id =  ");
        query.push_bind(_q.user_id);

        query.push(" order by login_id desc limit ");

        query.push_bind((_q.page_number - 1) * _q.page_size);
        query.push(",");
        query.push_bind(_q.page_size);

        let logs: Vec<SignInRecordWithName> = query.build_query_as().fetch_all(pool).await?;

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
        query = QueryBuilder::new("SELECT count(login_id) as count,login_state FROM user_login LEFT JOIN `user` ON user_login.user_id = `user`.user_id WHERE `user`.is_deleted = 0 ")
    }

    query.push(" GROUP BY user_login.login_state");
    let result: Vec<SignInSummary> = query.build_query_as().fetch_all(pool).await?;

    anyhow::Ok(result)
}

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct UserSignInSummary {
    pub count: i64,
    pub user_name: String,
}

pub async fn get_user_sign_in_summary(
    pool: &Pool<MySql>,
    user_id: i64,
) -> anyhow::Result<Vec<UserSignInSummary>> {
    let mut query: QueryBuilder<'_, _>;
    if user_id != 1 {
        query = QueryBuilder::new("SELECT count(login_id) as count,`user`.user_name FROM user_login LEFT JOIN `user` ON user_login.user_id = `user`.user_id WHERE `user`.is_deleted = 0  and `user`.user_id = ");
        query.push_bind(user_id);
    } else {
        query = QueryBuilder::new("SELECT count(login_id) as count,`user`.user_name FROM user_login LEFT JOIN `user` ON user_login.user_id = `user`.user_id WHERE `user`.is_deleted = 0 ")
    }

    query.push(" GROUP BY user_login.user_id order by count desc limit 0,3");
    let result: Vec<UserSignInSummary> = query.build_query_as().fetch_all(pool).await?;

    anyhow::Ok(result)
}
