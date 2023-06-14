use actix_web::{web, HttpRequest, HttpResponse};

use crate::{
    common::base_response::BaseResponse, database::init::POOL, middleware::UserId,
    models::user_login, services::DataList, services::Query,
};

pub async fn get_all(req: HttpRequest, c: Option<web::ReqData<UserId>>) -> HttpResponse {
    let page = web::Query::<super::Pagination>::from_query(req.query_string());
    let pagination: super::Pagination;
    match page {
        Ok(p) => {
            pagination = p.0;
        }
        Err(_) => {
            pagination = super::Pagination {
                page_number: 1,
                page_size: 10,
            }
        }
    }

    if let Some(c) = c {
        let user_id = c.into_inner().user_id;
        if user_id != 1 {
            let b: BaseResponse<Option<String>> = BaseResponse {
                code: 20001,
                message: "当前用户无法查询全部",
                data: None,
            };
            return HttpResponse::Ok().body(serde_json::to_string(&b).unwrap());
        } else {
            let pool = POOL.lock().unwrap();
            let logs = user_login::UserLogin::all(
                pool.get_pool(),
                pagination.page_size,
                pagination.page_number,
            )
            .await;
            match logs {
                Ok(_logs) => {
                    let b: BaseResponse<DataList<user_login::UserLogin>> = BaseResponse {
                        code: 20000,
                        message: "查询成功",
                        data: _logs,
                    };
                    return HttpResponse::Ok().body(serde_json::to_string(&b).unwrap());
                }
                Err(e) => {
                    println!("[rust error] : {:?}", e);
                    let b: BaseResponse<Option<String>> = BaseResponse {
                        code: 20001,
                        message: "查询失败",
                        data: None,
                    };
                    return HttpResponse::Ok().body(serde_json::to_string(&b).unwrap());
                }
            }
        }
    } else {
        let b: BaseResponse<Option<String>> = BaseResponse {
            code: 20001,
            message: "获取用户信息失败",
            data: None,
        };
        return HttpResponse::Ok().body(serde_json::to_string(&b).unwrap());
    }
}

pub async fn get_current(req: HttpRequest, c: Option<web::ReqData<UserId>>) -> HttpResponse {
    let page = web::Query::<super::Pagination>::from_query(req.query_string());
    let pagination: super::Pagination;
    match page {
        Ok(p) => {
            pagination = p.0;
        }
        Err(_) => {
            pagination = super::Pagination {
                page_number: 1,
                page_size: 10,
            }
        }
    }

    if let Some(c) = c {
        let user_id = c.into_inner().user_id;

        let pool = POOL.lock().unwrap();
        let logs = user_login::UserLogin::by_id_many(
            user_id,
            pool.get_pool(),
            pagination.page_size,
            pagination.page_number,
        )
        .await;
        match logs {
            Ok(_logs) => {
                let b: BaseResponse<DataList<user_login::UserLogin>> = BaseResponse {
                    code: 20000,
                    message: "查询成功",
                    data: _logs,
                };
                return HttpResponse::Ok().body(serde_json::to_string(&b).unwrap());
            }
            Err(e) => {
                println!("[rust error] : {:?}", e);
                let b: BaseResponse<Option<String>> = BaseResponse {
                    code: 20001,
                    message: "查询失败",
                    data: None,
                };
                return HttpResponse::Ok().body(serde_json::to_string(&b).unwrap());
            }
        }
    } else {
        let b: BaseResponse<Option<String>> = BaseResponse {
            code: 20001,
            message: "获取用户信息失败",
            data: None,
        };
        return HttpResponse::Ok().body(serde_json::to_string(&b).unwrap());
    }
}
