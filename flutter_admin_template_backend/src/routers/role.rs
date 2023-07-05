use actix_web::{error, web, HttpResponse};

use crate::common::base_response::BaseResponse;

pub fn role_group(config: &mut web::ServiceConfig) {
    config.service(
        web::scope("/system/role")
            .app_data(web::JsonConfig::default().error_handler(|err, _req| {
                println!("[rust-error] : {:?} ", err);

                let a = BaseResponse {
                    code: crate::constants::BAD_REQUEST,
                    message: "参数验证失败",
                    data: "",
                };

                let body = serde_json::to_string(&a).unwrap();

                error::InternalError::from_response(err, HttpResponse::Ok().body(body)).into()
            }))
            .route(
                "/all",
                web::get().to(crate::controllers::role_controller::get_all_roles),
            )
            .route(
                "/details/current",
                web::get().to(crate::controllers::role_controller::get_current_user_role_detail),
            )
            .route(
                "/details",
                web::get().to(crate::controllers::role_controller::get_detail_by_id),
            )
            .route(
                "/update",
                web::post().to(crate::controllers::role_controller::update_role),
            ),
    );
}
