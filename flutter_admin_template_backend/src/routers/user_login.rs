use crate::common::base_response::BaseResponse;
use crate::controllers::user_login_controller;
use actix_web::{error, web, HttpResponse};

pub fn user_login_group(config: &mut web::ServiceConfig) {
    config.service(
        web::scope("/system/login")
            .app_data(web::JsonConfig::default().error_handler(|err, _req| {
                println!("[rust-error] : {:?} ", err);

                let a = BaseResponse {
                    code: 20001,
                    message: "参数验证失败",
                    data: "",
                };

                let body = serde_json::to_string(&a).unwrap();

                error::InternalError::from_response(err, HttpResponse::Ok().body(body)).into()
            }))
            .route("/all", web::get().to(user_login_controller::get_all))
            .route(
                "/current",
                web::get().to(user_login_controller::get_current),
            ),
    );
}
