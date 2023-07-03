use actix_web::{
    web::{self, ReqData},
    HttpRequest, HttpResponse,
};

use crate::{
    common::base_response::BaseResponse,
    database::init::POOL,
    middleware::UserId,
    services::{
        api_service::{ApiSummary, ApiTrait},
        query_params::DataList,
    },
};

#[derive(Debug, serde::Deserialize)]
struct QueryParams {
    pub id: i64,
}

pub async fn get_apis_by_role_id(req: HttpRequest) -> HttpResponse {
    let q = web::Query::<QueryParams>::from_query(req.query_string());

    if let Ok(_q) = q {
        let pool = POOL.lock().unwrap();
        let r = crate::services::api_service::ApiService::query_by_role_id(_q.id, pool.get_pool())
            .await;
        if let Ok(_r) = r {
            let b: BaseResponse<DataList<ApiSummary>> = BaseResponse {
                code: crate::constants::OK,
                message: "查询成功",
                data: DataList {
                    count: _r.len() as i64,
                    records: _r,
                },
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

pub async fn get_apis_by_router_id(req: HttpRequest) -> HttpResponse {
    let q = web::Query::<QueryParams>::from_query(req.query_string());

    if let Ok(_q) = q {
        let pool = POOL.lock().unwrap();
        let r =
            crate::services::api_service::ApiService::query_by_router_id(_q.id, pool.get_pool())
                .await;
        if let Ok(_r) = r {
            let b: BaseResponse<DataList<ApiSummary>> = BaseResponse {
                code: crate::constants::OK,
                message: "查询成功",
                data: DataList {
                    count: _r.len() as i64,
                    records: _r,
                },
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

pub async fn get_apis_by_current_user(user_id: Option<ReqData<UserId>>) -> HttpResponse {
    if let Some(_id) = user_id {
        let pool = POOL.lock().unwrap();
        let r =
            crate::services::api_service::ApiService::query_current(_id.user_id, pool.get_pool())
                .await;
        if let Ok(_r) = r {
            let b: BaseResponse<DataList<ApiSummary>> = BaseResponse {
                code: crate::constants::OK,
                message: "查询成功",
                data: DataList {
                    count: _r.len() as i64,
                    records: _r,
                },
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
