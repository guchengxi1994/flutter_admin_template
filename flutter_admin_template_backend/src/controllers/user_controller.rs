use actix_web::{
    web::{self, ReqData},
    HttpRequest, HttpResponse,
};

use crate::{
    common::base_response::BaseResponse,
    middleware::UserId,
    models::user::User,
    services::user_service::{NewUserRequest, UserLoginRequest, UserTrait},
};

pub async fn new_user(info: web::Json<NewUserRequest>) -> HttpResponse {
    let pool = crate::database::init::POOL.lock().await;
    let r = crate::services::user_service::UserService::new_user(pool.get_pool(), info.0).await;
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
        let r =
            crate::services::user_service::UserService::login(info.0, ip).await;
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

pub async fn get_current_user_info(user_id: Option<ReqData<UserId>>) -> HttpResponse {
    if let Some(_id) = user_id {
        let pool = crate::database::init::POOL.lock().await;
        let u =
            crate::services::user_service::UserService::get_user_info(pool.get_pool(), _id.user_id)
                .await;
        if let Ok(_u) = u {
            let b: BaseResponse<Option<User>> = BaseResponse {
                code: crate::constants::OK,
                message: "",
                data: Some(_u),
            };
            return HttpResponse::Ok().json(&b);
        }
    }

    let b: BaseResponse<Option<String>> = BaseResponse {
        code: crate::constants::INVALID_USER,
        message: "获取人员信息失败",
        data: None,
    };
    return HttpResponse::Ok().json(&b);
}
