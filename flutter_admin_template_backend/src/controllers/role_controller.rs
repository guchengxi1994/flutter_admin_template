use actix_web::HttpResponse;

use crate::{
    common::base_response::BaseResponse,
    database::init::POOL,
    models::role::Role,
    services::{query_params::DataList, role_service::RoleTrait},
};

pub async fn get_all_roles() -> HttpResponse {
    let pool = POOL.lock().unwrap();
    let roles = crate::services::role_service::RoleService::query_all(pool.get_pool()).await;
    match roles {
        Ok(_r) => {
            let b: BaseResponse<DataList<Role>> = BaseResponse {
                code: crate::constants::OK,
                message: "查询成功",
                data: DataList {
                    count: _r.len() as i64,
                    records: _r,
                },
            };
            return HttpResponse::Ok().json(&b);
        }
        Err(e) => {
            println!("[rust error] : {:?}", e);
            let b: BaseResponse<Option<String>> = BaseResponse {
                code: crate::constants::BAD_REQUEST,
                message: "查询失败",
                data: None,
            };
            return HttpResponse::Ok().json(&b);
        }
    }
}
