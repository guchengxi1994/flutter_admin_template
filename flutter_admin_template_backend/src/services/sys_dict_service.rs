use sqlx::{MySql, Pool};
use validator::{Validate, ValidationError};

use crate::models::sys_dict::{SysDict, SysDictData};

pub struct SysDictService;

#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct SysDictDetails {
    pub dict_id: i64,
    pub dict_name: String,
    pub dict_type: String,
    pub create_time: chrono::DateTime<chrono::Local>,
    pub update_time: chrono::DateTime<chrono::Local>,
    pub remark: Option<String>,
    pub values: Vec<String>,
}

fn validate_dict_type(dict_type: &str) -> Result<(), ValidationError> {
    let a = crate::common::regex::SYS_DICT_REGEX.lock().unwrap();
    if !a.is_match(dict_type) {
        return Err(ValidationError::new("error regex dict type"));
    }

    Ok(())
}

#[derive(Clone, Debug, Validate, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct NewSysDictRequest {
    pub dict_name: String,
    #[validate(length(min = 5), custom = "validate_dict_type")]
    pub dict_type: String,
    pub dict_labels: Vec<String>,
}

#[derive(Clone, Debug, Validate, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct UpdateSysDictRequest {
    pub dict_name: String,
    #[validate(length(min = 5), custom = "validate_dict_type")]
    pub dict_type: String,
    pub dict_labels: Vec<String>,
    pub dict_id: i64,
}

#[async_trait::async_trait]
pub trait SysDictTrait {
    async fn query_all_sys_dict(pool: &Pool<MySql>) -> anyhow::Result<Vec<SysDict>>;

    async fn query_by_id(id: i64, pool: &Pool<MySql>) -> anyhow::Result<SysDictDetails>;

    async fn query_by_type(dict_type: String, pool: &Pool<MySql>) -> anyhow::Result<SysDict>;

    async fn create_dict(req: NewSysDictRequest, pool: &Pool<MySql>) -> anyhow::Result<()>;

    async fn delete_dict_by_id(id: i64, pool: &Pool<MySql>) -> anyhow::Result<()>;

    async fn update_dict(req: UpdateSysDictRequest, pool: &Pool<MySql>) -> anyhow::Result<()>;
}

#[async_trait::async_trait]
impl SysDictTrait for SysDictService {
    async fn query_all_sys_dict(pool: &Pool<MySql>) -> anyhow::Result<Vec<SysDict>> {
        let r = sqlx::query_as::<MySql, SysDict>(r#"select * from dict where is_deleted = 0"#)
            .fetch_all(pool)
            .await?;
        anyhow::Ok(r)
    }

    async fn query_by_id(id: i64, pool: &Pool<MySql>) -> anyhow::Result<SysDictDetails> {
        let r = sqlx::query_as::<MySql, SysDict>(
            r#"select * from dict where is_deleted = 0 and dict_id = ?"#,
        )
        .bind(id)
        .fetch_one(pool)
        .await?;

        let labels = sqlx::query_as::<MySql, SysDictData>(
            r#"select * from dict_data where is_deleted = 0 and dict_id = ?"#,
        )
        .bind(id)
        .fetch_all(pool)
        .await?;

        anyhow::Ok(SysDictDetails {
            dict_id: r.dict_id,
            dict_name: r.dict_name,
            dict_type: r.dict_type,
            create_time: r.create_time,
            update_time: r.update_time,
            remark: r.remark,
            values: labels.iter().map(|e| e.dict_label.clone()).collect(),
        })
    }

    async fn create_dict(req: NewSysDictRequest, pool: &Pool<MySql>) -> anyhow::Result<()> {
        if let Err(_e) = req.validate() {
            anyhow::bail!("参数错误")
        }

        let d = Self::query_by_type(req.dict_type.clone(), pool).await;

        if let Ok(_d) = d {
            anyhow::bail!("已存在重复数据")
        }

        let mut tx = pool.begin().await?;
        let r = sqlx::query(r#"insert into dict (dict_name,dict_type) values (?,?)"#)
            .bind(req.dict_name)
            .bind(req.dict_type)
            .execute(&mut tx)
            .await?;

        for i in req.dict_labels.iter() {
            let _ = sqlx::query(r#"insert into dict_data (dict_id,dict_label)"#)
                .bind(r.last_insert_id())
                .bind(i)
                .execute(&mut tx)
                .await?;
        }

        tx.commit().await?;

        anyhow::Ok(())
    }

    async fn query_by_type(dict_type: String, pool: &Pool<MySql>) -> anyhow::Result<SysDict> {
        let r = sqlx::query_as::<MySql, SysDict>(
            r#"select * from dict where is_deleted = 0 and dict_type = ?"#,
        )
        .bind(dict_type)
        .fetch_one(pool)
        .await?;

        anyhow::Ok(r)
    }

    async fn delete_dict_by_id(id: i64, pool: &Pool<MySql>) -> anyhow::Result<()> {
        let mut tx = pool.begin().await?;
        let _ = sqlx::query(r#"update dict set is_deleted = 1 where dict_id = ?"#)
            .bind(id)
            .execute(&mut tx)
            .await?;

        let _ = sqlx::query(r#"update dict_data set is_deleted = 1 where dict_id = ?"#)
            .bind(id)
            .execute(&mut tx)
            .await?;

        tx.commit().await?;

        anyhow::Ok(())
    }

    async fn update_dict(req: UpdateSysDictRequest, pool: &Pool<MySql>) -> anyhow::Result<()> {
        if let Err(_e) = req.validate() {
            anyhow::bail!("参数错误")
        }

        let d = sqlx::query_as::<sqlx::MySql, SysDict>(
            r#"select * from dict where is_deleted = 0 and dict_id = ?"#,
        )
        .bind(req.dict_id)
        .fetch_one(pool)
        .await;

        if let Err(e) = d {
            println!("[rust-error]: {:?}", e);
            anyhow::bail!("数据不存在")
        }

        let d = Self::query_by_type(req.dict_type.clone(), pool).await;

        if let Ok(_d) = d {
            anyhow::bail!("已存在重复数据")
        }

        let mut tx = pool.begin().await?;

        let _ = sqlx::query(r#"update dict_data set is_deleted = 1 where dict_id = ?"#)
            .bind(req.dict_id)
            .execute(&mut tx)
            .await?;

        let _ = sqlx::query(
            r#"update dict set dict_name = ?,dict_type=? where is_deleted = 0 and dict_id = ?"#,
        )
        .bind(req.dict_name)
        .bind(req.dict_type)
        .bind(req.dict_id)
        .execute(&mut tx)
        .await?;

        for i in req.dict_labels.iter() {
            let _ = sqlx::query(r#"insert into dict_data (dict_id,dict_label)"#)
                .bind(req.dict_id)
                .bind(i)
                .execute(&mut tx)
                .await?;
        }

        tx.commit().await?;

        anyhow::Ok(())
    }
}
