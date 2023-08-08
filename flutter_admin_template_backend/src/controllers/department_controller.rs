use actix_web::{HttpRequest, HttpResponse};

use crate::{
    common::base_response::BaseResponse,
    database::init::POOL,
    services::department_service::{DepartmentTrait, StructuredDepartment},
};

pub async fn get_department_tree(_req: HttpRequest) -> HttpResponse {
    let pool = POOL.lock().unwrap();
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
