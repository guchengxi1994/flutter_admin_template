use sqlx::{MySql, Pool};
use validator::{Validate, ValidationError};

use crate::models::sys_config::SysConfig;

fn validate_config_key(key: &str) -> Result<(), ValidationError> {
    let a = crate::common::regex::SYS_CONFIG_REGEX.lock().unwrap();
    if !a.is_match(key) {
        return Err(ValidationError::new("error regex key"));
    }

    Ok(())
}

#[derive(Clone, Debug, Validate, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct NewSysConfigRequest {
    pub value: String,
    #[validate(length(min = 5), custom = "validate_config_key")]
    pub key: String,
}

#[derive(Clone, Debug, Validate, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct UpdateSysConfigRequest {
    pub value: String,
    #[validate(length(min = 5), custom = "validate_config_key")]
    pub key: String,
    pub config_id: i64,
}

#[async_trait::async_trait]
pub trait SysConfigTrait {
    async fn query_all_sys_config(pool: &Pool<MySql>) -> anyhow::Result<Vec<SysConfig>>;

    async fn query_by_id(id: i64, pool: &Pool<MySql>) -> anyhow::Result<SysConfig>;

    async fn create_config(req: NewSysConfigRequest, pool: &Pool<MySql>) -> anyhow::Result<()>;

    async fn query_by_name(config_name: String, pool: &Pool<MySql>) -> anyhow::Result<SysConfig>;

    async fn delete_config_by_id(id: i64, pool: &Pool<MySql>) -> anyhow::Result<()>;

    async fn update_config(req: UpdateSysConfigRequest, pool: &Pool<MySql>) -> anyhow::Result<()>;
}

pub struct SysConfigService;

#[async_trait::async_trait]
impl SysConfigTrait for SysConfigService {
    async fn query_all_sys_config(pool: &Pool<MySql>) -> anyhow::Result<Vec<SysConfig>> {
        let r = sqlx::query_as::<sqlx::MySql, SysConfig>(
            r#"select * from config where is_deleted = 0"#,
        )
        .fetch_all(pool)
        .await?;
        anyhow::Ok(r)
    }

    async fn query_by_id(id: i64, pool: &Pool<MySql>) -> anyhow::Result<SysConfig> {
        let r = sqlx::query_as::<sqlx::MySql, SysConfig>(
            r#"select * from config where is_deleted = 0 and config_id = ?"#,
        )
        .bind(id)
        .fetch_one(pool)
        .await?;
        anyhow::Ok(r)
    }

    async fn create_config(req: NewSysConfigRequest, pool: &Pool<MySql>) -> anyhow::Result<()> {
        if let Err(_e) = req.validate() {
            anyhow::bail!("参数错误")
        }

        let d = Self::query_by_name(req.key.clone(), pool).await;

        if let Ok(_d) = d {
            anyhow::bail!("已存在重复数据")
        }

        let _ = sqlx::query(r#"INSERT INTO config (config_key,config_value) values (?,?)"#)
            .bind(req.key)
            .bind(req.value)
            .execute(pool)
            .await?;

        anyhow::Ok(())
    }

    async fn delete_config_by_id(id: i64, pool: &Pool<MySql>) -> anyhow::Result<()> {
        let _ = sqlx::query(r#"update config set is_deleted = 1 where config_id = ?"#)
            .bind(id)
            .execute(pool)
            .await?;
        anyhow::Ok(())
    }

    async fn update_config(req: UpdateSysConfigRequest, pool: &Pool<MySql>) -> anyhow::Result<()> {
        if let Err(_e) = req.validate() {
            anyhow::bail!("参数错误")
        }

        let d = Self::query_by_name(req.key.clone(), pool).await;

        if let Ok(_d) = d {
            anyhow::bail!("已存在重复数据")
        }

        let _ = sqlx::query(r#"update config set config_key = ?,config_value = ?"#)
            .bind(req.key)
            .bind(req.value)
            .execute(pool)
            .await?;

        anyhow::Ok(())
    }

    async fn query_by_name(config_name: String, pool: &Pool<MySql>) -> anyhow::Result<SysConfig> {
        let r = sqlx::query_as::<sqlx::MySql, SysConfig>(
            r#"select * from config where is_deleted = 0 and config_key = ?"#,
        )
        .bind(config_name)
        .fetch_one(pool)
        .await?;
        anyhow::Ok(r)
    }
}
