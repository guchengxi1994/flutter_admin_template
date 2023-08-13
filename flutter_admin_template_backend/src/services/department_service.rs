extern crate fat_macros;

use serde::Deserialize;
use sqlx::{types::chrono, MySql, Pool};
use validator::Validate;

use crate::models::department::Department;

#[derive(Debug, Validate, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct NewDeptRequest {
    #[validate(length(max = 30))]
    pub dept_name: String,
    #[validate(range(min = 0))]
    pub parent_id: i64,
    #[validate(range(min = 0))]
    pub order_number: i64,
    #[validate(length(max = 50))]
    pub remark: Option<String>,
}

#[derive(Debug, Validate, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct UpdateDeptRequest {
    #[validate(length(max = 30))]
    pub dept_name: String,
    #[validate(range(min = 0))]
    pub parent_id: i64,
    #[validate(range(min = 0))]
    pub order_number: i64,
    #[validate(length(max = 50))]
    pub remark: Option<String>,
    #[validate(range(min = 1))]
    pub dept_id: i64,
}

#[allow(dead_code)]
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

#[derive(Clone, Debug, serde::Deserialize, serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct SingleDepartment {
    pub dept_id: i64,
    pub parent_dept_name: String,
    pub dept_name: String,
    pub order_number: i64,
    pub create_time: chrono::DateTime<chrono::Local>,
    pub remark: Option<String>,
}

#[async_trait::async_trait]
pub trait DepartmentTrait {
    /// 根据id获取单个department
    async fn query_by_dept_id(dept_id: i64, pool: &Pool<MySql>) -> anyhow::Result<Department>;

    /// 根据parent_id获取该节点下所有departments
    async fn query_by_parent_id(
        parent_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<StructuredDepartment>;

    /// 获取部门树
    async fn query_structured_depts(pool: &Pool<MySql>) -> anyhow::Result<StructuredDepartment>;

    /// 判断是否存在
    async fn exists(dept_id: i64, pool: &Pool<MySql>) -> bool;

    /// 获取所有部门
    async fn get_all_departments(pool: &Pool<MySql>) -> anyhow::Result<Vec<Department>>;

    /// 获取不包括该id的所有部门
    async fn get_departments_without(
        without: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<Vec<Department>>;

    /// 创建新的部门
    async fn create_new_dept(req: NewDeptRequest, pool: &Pool<MySql>) -> anyhow::Result<()>;

    /// 更新部门
    async fn update_dept(req: UpdateDeptRequest, pool: &Pool<MySql>) -> anyhow::Result<()>;

    /// 获取不包含自身及自身下所有子部门的部门树
    async fn get_structured_depts_without_self(
        dept_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<StructuredDepartment>;

    /// 根据id获取dept详情
    async fn query_single_dept_detail_by_id(
        dept_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<SingleDepartment>;
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
            r#"select * from department where is_deleted = 0  order by parent_id,order_number"#,
        )
        .fetch_all(pool)
        .await?;

        anyhow::Ok(r)
    }

    async fn get_departments_without(
        without: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<Vec<Department>> {
        let r = sqlx::query_as::<sqlx::MySql, Department>(
            r#"select * from department where is_deleted = 0 and dept_id!= ?  order by parent_id,order_number"#,
        )
        .bind(without)
        .fetch_all(pool)
        .await?;

        anyhow::Ok(r)
    }

    async fn create_new_dept(req: NewDeptRequest, pool: &Pool<MySql>) -> anyhow::Result<()> {
        if let Err(_e) = req.validate() {
            anyhow::bail!("参数错误")
        }

        let b = Self::exists(req.parent_id, pool).await;
        if !b {
            anyhow::bail!("record not found")
        }

        let r = sqlx::query_as::<sqlx::MySql, Department>(
            r#"select * from department where is_deleted = 0  and parent_id = ? and dept_name = ?"#,
        )
        .bind(req.parent_id)
        .bind(&req.dept_name)
        .fetch_one(pool)
        .await;
        if let Ok(_r) = r {
            anyhow::bail!("duplicated department name")
        }

        let _ = sqlx::query(
            r#"insert into department (parent_id,dept_name,order_number,remark) values (?,?,?,?)"#,
        )
        .bind(req.parent_id)
        .bind(req.dept_name)
        .bind(req.order_number)
        .bind(req.remark)
        .execute(pool)
        .await?;

        anyhow::Ok(())
    }

    #[fat_macros::need_more_tests]
    async fn update_dept(req: UpdateDeptRequest, pool: &Pool<MySql>) -> anyhow::Result<()> {
        if let Err(_e) = req.validate() {
            anyhow::bail!("参数错误")
        }

        let b = Self::exists(req.parent_id, pool).await;
        if !b {
            anyhow::bail!("record not found")
        }

        let b = Self::exists(req.dept_id, pool).await;
        if !b {
            anyhow::bail!("record not found")
        }

        let s = Self::query_by_parent_id(req.dept_id, pool).await;
        if let Ok(_s) = s {
            if if_has_root(req.parent_id, &_s) {
                anyhow::bail!("cannot move parent node to child node")
            }
        }

        let r = sqlx::query_as::<sqlx::MySql, Department>(
            r#"select * from department where is_deleted = 0  and parent_id = ? and dept_name = ?"#,
        )
        .bind(req.parent_id)
        .bind(&req.dept_name)
        .fetch_one(pool)
        .await;
        if let Ok(_r) = r {
            anyhow::bail!("duplicated department name")
        }

        let  _ = sqlx::query(r#"update department set parent_id = ?,dept_name=?,order_number=?,remark=? where is_deleted = 0 and dept_id = ?"#).bind(req.parent_id).bind(req.dept_name).bind(req.order_number).bind(req.remark).bind(req.dept_id).execute(pool).await?;

        anyhow::Ok(())
    }

    #[fat_macros::need_more_tests]
    async fn get_structured_depts_without_self(
        dept_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<StructuredDepartment> {
        let b = Self::exists(dept_id, pool).await;
        if !b {
            anyhow::bail!("record not found")
        }

        if dept_id == 1 {
            anyhow::bail!("wrong parameter")
        }

        let depts = Self::get_departments_without(dept_id, pool).await?;

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

    async fn query_single_dept_detail_by_id(
        dept_id: i64,
        pool: &Pool<MySql>,
    ) -> anyhow::Result<SingleDepartment> {
        let dept = Self::query_by_dept_id(dept_id, pool).await?;
        let result: SingleDepartment;

        if dept.parent_id == 0 {
            result = SingleDepartment {
                dept_id: dept.dept_id,
                parent_dept_name: "--".to_string(),
                dept_name: dept.dept_name,
                create_time: dept.create_time,
                order_number: dept.order_number,
                remark: dept.remark,
            };
        } else {
            let parent_dept = Self::query_by_dept_id(dept.parent_id, pool).await?;

            result = SingleDepartment {
                dept_id: dept.dept_id,
                parent_dept_name: parent_dept.dept_name,
                dept_name: dept.dept_name,
                create_time: dept.create_time,
                order_number: dept.order_number,
                remark: dept.remark,
            };
        }

        anyhow::Ok(result)
    }
}

fn if_has_root(parent_id: i64, s: &StructuredDepartment) -> bool {
    if parent_id == s.dept_id {
        return true;
    }
    for child_dept in s.children.iter() {
        if child_dept.dept_id == parent_id {
            return true;
        }
        return if_has_root(parent_id, child_dept);
    }

    false
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
