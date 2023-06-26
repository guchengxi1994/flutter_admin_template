use actix_web::{web, HttpRequest, HttpResponse};

use crate::{
    common::base_response::BaseResponse,
    database::init::POOL,
    middleware::UserId,
    models::sign_in_record,
    services::Query,
    services::{
        log_service::SignInSummary,
        query_params::{DataList, Pagination, QueryParam, SigninRecordsQueryParam},
    },
};

pub async fn sign_in_get_all(req: HttpRequest, c: Option<web::ReqData<UserId>>) -> HttpResponse {
    let page = web::Query::<SigninRecordsQueryParam>::from_query(req.query_string());
    let pagination: SigninRecordsQueryParam;
    match page {
        Ok(p) => {
            pagination = p.0;
        }
        Err(_) => {
            pagination = SigninRecordsQueryParam {
                page_number: 1,
                page_size: 10,
                username: None,
                user_id: None,
                start_time: None,
                end_time: None,
                state: None,
            }
        }
    }

    let c1 = c.clone();

    if let Some(c) = c {
        let user_id = c.into_inner().user_id;
        if user_id != 1 {
            // let b: BaseResponse<Option<String>> = BaseResponse {
            //     code: crate::constants::BAD_REQUEST,
            //     message: "当前用户无法查询全部",
            //     data: None,
            // };
            // return HttpResponse::Ok().json(&b);
            return sign_in_get_current(req, c1).await;
        } else {
            let pool = POOL.lock().unwrap();
            let logs =
                sign_in_record::SignInRecord::all(pool.get_pool(), QueryParam { data: pagination })
                    .await;
            match logs {
                Ok(_logs) => {
                    let b: BaseResponse<DataList<sign_in_record::SignInRecord>> = BaseResponse {
                        code: crate::constants::OK,
                        message: "查询成功",
                        data: _logs,
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
    } else {
        let b: BaseResponse<Option<String>> = BaseResponse {
            code: crate::constants::BAD_REQUEST,
            message: "获取用户信息失败",
            data: None,
        };
        return HttpResponse::Ok().json(&b);
    }
}

pub async fn sign_in_get_current(
    req: HttpRequest,
    c: Option<web::ReqData<UserId>>,
) -> HttpResponse {
    let page = web::Query::<Pagination>::from_query(req.query_string());
    let pagination: Pagination;
    match page {
        Ok(p) => {
            pagination = p.0;
        }
        Err(_) => {
            pagination = Pagination {
                page_number: 1,
                page_size: 10,
            }
        }
    }

    if let Some(c) = c {
        let user_id = c.into_inner().user_id;

        let pool = POOL.lock().unwrap();
        let logs = sign_in_record::SignInRecord::current_many(
            user_id,
            pool.get_pool(),
            QueryParam { data: pagination },
        )
        .await;
        match logs {
            Ok(_logs) => {
                let b: BaseResponse<DataList<sign_in_record::SignInRecord>> = BaseResponse {
                    code: crate::constants::OK,
                    message: "查询成功",
                    data: _logs,
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
    } else {
        let b: BaseResponse<Option<String>> = BaseResponse {
            code: crate::constants::BAD_REQUEST,
            message: "获取用户信息失败",
            data: None,
        };
        return HttpResponse::Ok().json(&b);
    }
}

#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct LogSummary {
    pub sign_in: Vec<SignInSummary>,
}

pub async fn get_log_summary(_req: HttpRequest, c: Option<web::ReqData<UserId>>) -> HttpResponse {
    let user_id: i64;
    if let Some(c) = c {
        user_id = c.into_inner().user_id;
    } else {
        let b: BaseResponse<Option<String>> = BaseResponse {
            code: crate::constants::BAD_REQUEST,
            message: "查询失败",
            data: None,
        };
        return HttpResponse::Ok().json(&b);
    }

    let pool = POOL.lock().unwrap();
    let summary =
        crate::services::log_service::get_sign_in_log_summary(pool.get_pool(), user_id).await;
    match summary {
        Ok(s) => {
            let b: BaseResponse<LogSummary> = BaseResponse {
                code: crate::constants::OK,
                message: "查询成功",
                data: LogSummary { sign_in: s },
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
