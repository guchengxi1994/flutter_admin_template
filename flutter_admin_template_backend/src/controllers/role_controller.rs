use actix_web::{web, web::ReqData, HttpRequest, HttpResponse};

use crate::{
    common::base_response::BaseResponse,
    database::init::POOL,
    middleware::UserId,
    models::role::Role,
    services::{
        query_params::DataList,
        role_service::{RoleDetails, RoleTrait},
    },
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

#[derive(Debug, serde::Deserialize)]
struct QueryParams {
    pub id: i64,
}

pub async fn get_detail_by_id(req: HttpRequest) -> HttpResponse {
    let q = web::Query::<QueryParams>::from_query(req.query_string());

    if let Ok(_q) = q {
        let pool = POOL.lock().unwrap();
        let r =
            crate::services::role_service::RoleService::query_details_by_id(_q.id, pool.get_pool())
                .await;

        if let Ok(_r) = r {
            let b: BaseResponse<RoleDetails> = BaseResponse {
                code: crate::constants::OK,
                message: "查询成功",
                data: _r,
            };
            return HttpResponse::Ok().json(&b);
        } else {
            println!("[rust] :{:?}", r.err());
        }
    }

    let b: BaseResponse<Option<String>> = BaseResponse {
        code: crate::constants::BAD_REQUEST,
        message: "查询失败",
        data: None,
    };
    return HttpResponse::Ok().json(&b);
}

pub async fn get_current_user_role_detail(user_id: Option<ReqData<UserId>>) -> HttpResponse {
    if let Some(_id) = user_id {
        let pool = POOL.lock().unwrap();
        let r = crate::services::role_service::RoleService::get_current_role_details(
            _id.user_id,
            pool.get_pool(),
        )
        .await;

        if let Ok(_r) = r {
            let b: BaseResponse<RoleDetails> = BaseResponse {
                code: crate::constants::OK,
                message: "查询成功",
                data: _r,
            };
            return HttpResponse::Ok().json(&b);
        } else {
            println!("[rust] :{:?}", r.err());
        }
    }

    let b: BaseResponse<Option<String>> = BaseResponse {
        code: crate::constants::BAD_REQUEST,
        message: "查询失败",
        data: None,
    };
    return HttpResponse::Ok().json(&b);
}