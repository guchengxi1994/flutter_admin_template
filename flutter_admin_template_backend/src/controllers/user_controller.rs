use actix_web::{web, HttpRequest, HttpResponse};

use crate::{
    common::base_response::BaseResponse,
    services::user_service::{NewUserRequest, UserLoginRequest},
};

pub async fn new_user(info: web::Json<NewUserRequest>) -> HttpResponse {
    let r = crate::models::user::User::new_user(info.0).await;
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

pub async fn login(info: web::Json<UserLoginRequest>, req: HttpRequest) -> HttpResponse {
    let ip: String;
    if let Some(val) = req.peer_addr() {
        // println!("Address {:?}", val.ip());
        ip = val.ip().to_string();
        let r = crate::models::user::User::login(info.0, ip).await;
        match r {
            Ok(_r) => {
                let b: BaseResponse<Option<String>> = BaseResponse {
                    code: crate::constants::OK,
                    message: "成功",
                    data: Some(_r),
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
    };
    let b: BaseResponse<Option<String>> = BaseResponse {
        code: crate::constants::BAD_REQUEST,
        message: "获取IP异常",
        data: None,
    };
    return HttpResponse::Ok().json(&b);
}
