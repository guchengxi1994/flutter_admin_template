use sqlx::{types::chrono, MySql, Pool};

use crate::models::department::Department;

impl Department {
    pub async fn parent(self, pool: &Pool<MySql>) -> Option<Self> {
        if self.parent_id == 0 {
            return Some(self);
        }
        let r = sqlx::query_as::<sqlx::MySql, Department>(
            r#"select * from department where is_deleted = 0 and dept_id = ?"#,
        )
        .bind(self.parent_id)
        .fetch_all(pool)
        .await;
        match r {
            Ok(r0) => {
                if r0.len() > 1 {
                    return None;
                }
                return Some(Department {
                    dept_id: r0[0].dept_id,
                    parent_id: r0[0].parent_id,
                    dept_name: r0[0].dept_name.clone(),
                    order_number: r0[0].order_number,
                    create_time: r0[0].create_time,
                    update_time: r0[0].update_time,
                    is_deleted: r0[0].is_deleted,
                    remark: r0[0].remark.clone(),
                });
            }
            Err(e) => {
                println!("[rust-error]: {:?}", e);
                return None;
            }
        }
    }
}

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
    pub level: u8,
}

#[async_trait::async_trait]
pub trait DepartmentTrait {
    async fn query_by_dept_id(dept_id: i64, pool: &Pool<MySql>) -> anyhow::Result<Department>;

    async fn query_by_parent_id(
        parent_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<StructuredDepartment>;

    async fn query_structured_depts(pool: &Pool<MySql>) -> anyhow::Result<StructuredDepartment>;

    async fn exists(dept_id: i64, pool: &Pool<MySql>) -> bool;

    async fn get_all_departments(pool: &Pool<MySql>) -> anyhow::Result<Vec<Department>>;
}

pub struct DepartmentService;

fn get_children_by_id(s: &StructuredDepartment, parent_id: i64) -> Option<&StructuredDepartment> {
    if parent_id == s.dept_id {
        return Some(s);
    }

    for _s in s.children.iter() {
        if _s.dept_id == parent_id {
            return Some(_s);
        }

        return get_children_by_id(_s, parent_id);
    }

    None
}

#[async_trait::async_trait]
impl DepartmentTrait for DepartmentService {
    async fn query_by_dept_id(dept_id: i64, pool: &Pool<MySql>) -> anyhow::Result<Department> {
        let r = sqlx::query_as::<sqlx::MySql, Department>(
            r#"select * from department where is_deleted = 0 and dept_id = ?"#,
        )
        .bind(dept_id)
        .fetch_one(pool)
        .await?;

        anyhow::Ok(r)
    }

    async fn query_by_parent_id(
        parent_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<StructuredDepartment> {
        let r = Self::query_structured_depts(pool).await?;

        let res = get_children_by_id(&r, parent_id);

        match res {
            Some(_res) => anyhow::Ok(_res.clone()),
            None => {
                anyhow::bail!("cannot find")
            }
        }
    }

    async fn query_structured_depts(pool: &Pool<MySql>) -> anyhow::Result<StructuredDepartment> {
        let depts = Self::get_all_departments(pool).await?;
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
            level: 1,
        };

        s_dept = get_structed(depts[1..].to_vec(), &mut s_dept, 1).clone();

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

    async fn get_all_departments(pool: &Pool<MySql>) -> anyhow::Result<Vec<Department>> {
        let r = sqlx::query_as::<sqlx::MySql, Department>(
            r#"select * from department where is_deleted = 0  order by parent_id"#,
        )
        .fetch_all(pool)
        .await?;

        anyhow::Ok(r)
    }
}

fn get_structed(
    data: Vec<Department>,
    current: &mut StructuredDepartment,
    current_level: u8,
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
            level: current_level + 1,
        };

        let child = get_structed(data[index + 1..].to_vec(), &mut s, current_level + 1);

        if child.parent_id == current.dept_id {
            current.children.push(child.clone());
        }

        index += 1;
    }

    current
}
