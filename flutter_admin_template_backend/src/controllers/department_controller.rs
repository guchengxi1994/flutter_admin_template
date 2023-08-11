use actix_web::{web, HttpRequest, HttpResponse};

use crate::{
    common::base_response::BaseResponse,
    database::init::POOL,
    models::department::Department,
    services::department_service::{
        DepartmentTrait, NewDeptRequest, StructuredDepartment, UpdateDeptRequest,
    },
};

#[derive(Debug, serde::Deserialize)]
struct QueryParams {
    pub id: i64,
}

pub async fn get_dept_by_id(_req: HttpRequest) -> HttpResponse {
    let q = web::Query::<QueryParams>::from_query(_req.query_string());
    if let Ok(_q) = q {
        let pool = POOL.lock().await;
        let result = crate::services::department_service::DepartmentService::query_by_dept_id(
            _q.id,
            pool.get_pool(),
        )
        .await;
        if let Ok(_r) = result {
            let b: BaseResponse<Department> = BaseResponse {
                code: crate::constants::OK,
                message: "查询成功",
                data: _r,
            };
            return HttpResponse::Ok().json(&b);
        } else {
            println!("[rust] :{:?}", result.err());
        }
    }

    let b: BaseResponse<Option<String>> = BaseResponse {
        code: crate::constants::BAD_REQUEST,
        message: "查询失败",
        data: None,
    };
    return HttpResponse::Ok().json(&b);
}

pub async fn get_department_tree(_req: HttpRequest) -> HttpResponse {
    let pool = POOL.lock().await;
    let department =
        crate::services::department_service::DepartmentService::query_structured_depts(
            pool.get_pool(),
        )
        .await;
    match department {
        Ok(d) => {
            let b: BaseResponse<StructuredDepartment> = BaseResponse {
                code: crate::constants::OK,
                message: "查询成功",
                data: d,
            };
            return HttpResponse::Ok().json(&b);
        }
        Err(e) => {
            println!("[rust-error] : {:?}", e);
            let b: BaseResponse<Option<String>> = BaseResponse {
                code: crate::constants::BAD_REQUEST,
                message: "查询失败",
                data: None,
            };
            return HttpResponse::Ok().json(&b);
        }
    }
}

pub async fn get_department_tree_without(_req: HttpRequest) -> HttpResponse {
    let q = web::Query::<QueryParams>::from_query(_req.query_string());

    if let Ok(_q) = q {
        let pool = POOL.lock().await;
        let department =
            crate::services::department_service::DepartmentService::query_structured_depts(
                pool.get_pool(),
            )
            .await;
        match department {
            Ok(d) => {
                let b: BaseResponse<StructuredDepartment> = BaseResponse {
                    code: crate::constants::OK,
                    message: "查询成功",
                    data: d,
                };
                return HttpResponse::Ok().json(&b);
            }
            Err(e) => {
                println!("[rust-error] : {:?}", e);
            }
        }
    }
    let b: BaseResponse<Option<String>> = BaseResponse {
        code: crate::constants::BAD_REQUEST,
        message: "查询失败",
        data: None,
    };
    return HttpResponse::Ok().json(&b);
}

pub async fn new_dept(info: web::Json<NewDeptRequest>) -> HttpResponse {
    let pool = crate::database::init::POOL.lock().await;
    let r = crate::services::department_service::DepartmentService::create_new_dept(
        info.0,
        pool.get_pool(),
    )
    .await;
    match r {
        Ok(_) => {
            let b: BaseResponse<Option<String>> = BaseResponse {
                code: crate::constants::OK,
                message: "成功",
                data: None,
            };
            return HttpResponse::Ok().json(&b);
        }
        Err(e) => {
            let err_str = e.to_string();
            let b: BaseResponse<Option<String>> = BaseResponse {
                code: crate::constants::BAD_REQUEST,
                message: err_str.as_str(),
                data: None,
            };
            return HttpResponse::Ok().json(&b);
        }
    }
}

pub async fn update_dept(info: web::Json<UpdateDeptRequest>) -> HttpResponse {
    let pool = crate::database::init::POOL.lock().await;
    let r = crate::services::department_service::DepartmentService::update_dept(
        info.0,
        pool.get_pool(),
    )
    .await;
    match r {
        Ok(_) => {
            let b: BaseResponse<Option<String>> = BaseResponse {
                code: crate::constants::OK,
                message: "成功",
                data: None,
            };
            return HttpResponse::Ok().json(&b);
        }
        Err(e) => {
            let err_str = e.to_string();
            let b: BaseResponse<Option<String>> = BaseResponse {
                code: crate::constants::BAD_REQUEST,
                message: err_str.as_str(),
                data: None,
            };
            return HttpResponse::Ok().json(&b);
        }
    }
}
