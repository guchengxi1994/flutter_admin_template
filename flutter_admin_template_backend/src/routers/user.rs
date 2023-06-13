use crate::common::base_response::BaseResponse;
use crate::controllers::user_controller;
use actix_web::{error, web, HttpResponse};

pub fn user_group(config: &mut web::ServiceConfig) {
    config.service(
        web::scope("/system/user")
            .app_data(web::JsonConfig::default().error_handler(|err, _req| {
                println!("[rust-error] : {:?} ", err);

                let a = BaseResponse {
                    code: 20001,
                    message: &format!("{:?}", err),
                    data: "",
                };

                let body = serde_json::to_string(&a).unwrap();

                error::InternalError::from_response(err, HttpResponse::Ok().body(body)).into()
            }))
            .route("/create", web::post().to(user_controller::new_user))
            .route("/login", web::post().to(user_controller::login)),
    );
}