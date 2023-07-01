use actix_web::{
    web::{self, ReqData},
    HttpRequest, HttpResponse,
};

use crate::{
    common::base_response::BaseResponse,
    database::init::POOL,
    middleware::UserId,
    models::router::Router,
    services::{
        query_params::DataList,
        router_service::{RouterTrait, RouterSummary},
    },
};

#[derive(Debug, serde::Deserialize)]
struct QueryParams {
    pub id: i64,
}

pub async fn get_all_routers() -> HttpResponse {
    let pool = POOL.lock().unwrap();
    let routers = crate::services::router_service::RouterService::query_all(pool.get_pool()).await;

    match routers {
        Ok(r) => {
            let b: BaseResponse<DataList<Router>> = BaseResponse {
                code: crate::constants::OK,
                message: "查询成功",
                data: DataList {
                    count: r.len() as i64,
                    records: r,
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

pub async fn get_summary_by_user_id(req: HttpRequest) -> HttpResponse {
    let q = web::Query::<QueryParams>::from_query(req.query_string());

    if let Ok(_q) = q {
        let pool = POOL.lock().unwrap();
        let r = crate::services::router_service::RouterService::query_by_id(pool.get_pool(), _q.id)
            .await;
        if let Ok(_r) = r {
            let b: BaseResponse<DataList<RouterSummary>> = BaseResponse {
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

pub async fn get_current_summary(user_id: Option<ReqData<UserId>>) -> HttpResponse {
    if let Some(_id) = user_id {
        let pool = POOL.lock().unwrap();
        let r = crate::services::router_service::RouterService::query_by_id(
            pool.get_pool(),
            _id.user_id,
        )
        .await;
    
        if let Ok(_r) = r {
            let b: BaseResponse<DataList<RouterSummary>> = BaseResponse {
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

pub async fn get_summary_by_role_id(req: HttpRequest) -> HttpResponse {
    let q = web::Query::<QueryParams>::from_query(req.query_string());

    if let Ok(_q) = q {
        let pool = POOL.lock().unwrap();
        let r = crate::services::router_service::RouterService::query_by_role_id(
            pool.get_pool(),
            _q.id,
        )
        .await;
        if let Ok(_r) = r {
            let b: BaseResponse<DataList<RouterSummary>> = BaseResponse {
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
