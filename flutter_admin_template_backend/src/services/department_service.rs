use sqlx::{types::chrono, MySql, Pool};

use crate::models::department::Department;

#[derive(Clone, Debug, serde::Deserialize, serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct StructuredDepartment {
    pub dept_id: i64,
    pub parent_id: i64,
    pub dept_name: String,
    pub order_number: i64,
    pub create_time: chrono::DateTime<chrono::Local>,
    pub remark: Option<String>,
    pub children: Vec<StructuredDepartment>,
}

#[async_trait::async_trait]
pub trait DepartmentTrait {
    async fn query_by_dept_id(dept_id: i64, pool: &Pool<MySql>) -> anyhow::Result<Department>;

    async fn query_by_parent_id(
        parent_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<Vec<Department>>;

    async fn query_structured_depts(
        dept_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<StructuredDepartment>;

    async fn exists(dept_id: i64, pool: &Pool<MySql>) -> bool;

    async fn get_children_candidates(
        dept_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<Vec<Department>>;
}

pub struct DepartmentService;

#[async_trait::async_trait]
impl DepartmentTrait for DepartmentService {
    async fn query_by_dept_id(dept_id: i64, pool: &Pool<MySql>) -> anyhow::Result<Department> {
        todo!()
    }

    async fn query_by_parent_id(
        parent_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<Vec<Department>> {
        todo!()
    }

    async fn query_structured_depts(
        dept_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<StructuredDepartment> {
        let is_exists: bool = Self::exists(dept_id, pool).await;
        if !is_exists {
            anyhow::bail!("record not found")
        }

        let depts = Self::get_children_candidates(dept_id, pool).await?;
        if depts.len() == 0 {
            anyhow::bail!("records not found")
        }

        let mut s_dept: StructuredDepartment = StructuredDepartment {
            dept_id: depts[0].dept_id,
            parent_id: depts[0].parent_id,
            dept_name: depts[0].dept_name.clone(),
            order_number: depts[0].order_number,
            create_time: depts[0].create_time,
            remark: depts[0].remark.clone(),
            children: Vec::new(),
        };

        s_dept = get_structed(depts[1..].to_vec(), &mut s_dept).clone();

        anyhow::Ok(s_dept)
    }

    async fn exists(dept_id: i64, pool: &Pool<MySql>) -> bool {
        let r = sqlx::query_as::<sqlx::MySql, Department>(
            r#"select * from department where is_deleted = 0 and dept_id = ?"#,
        )
        .bind(dept_id)
        .fetch_one(pool)
        .await;

        match r {
            Ok(_) => true,
            Err(e) => {
                println!("[rust-error]: {:?}", e);
                return false;
            }
        }
    }

    async fn get_children_candidates(
        dept_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<Vec<Department>> {
        let r = sqlx::query_as::<sqlx::MySql, Department>(
            r#"select * from department where is_deleted = 0 and (parent_id >= ?  or dept_id = ?) order by parent_id"#,
        )
        .bind(dept_id)
        .bind(dept_id)
        .fetch_all(pool)
        .await?;

        anyhow::Ok(r)
    }
}

fn get_structed(
    data: Vec<Department>,
    current: &mut StructuredDepartment,
) -> &StructuredDepartment {
    let mut index = 0;
    while index < data.len() {
        let mut s = StructuredDepartment {
            dept_id: data[index].dept_id,
            parent_id: data[index].parent_id,
            dept_name: data[index].dept_name.clone(),
            order_number: data[index].order_number,
            create_time: data[index].create_time,
            remark: data[index].remark.clone(),
            children: Vec::new(),
        };

        let child = get_structed(data[index + 1..].to_vec(), &mut s);

        if child.parent_id == current.dept_id {
            current.children.push(child.clone());
        }

        index += 1;
    }

    current
}
