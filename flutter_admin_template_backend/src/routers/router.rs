use actix_web::{error, web, HttpResponse};

use crate::common::base_response::BaseResponse;

pub fn router_group(config: &mut web::ServiceConfig) {
    config.service(
        web::scope("/system/router")
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
                web::get().to(crate::controllers::router_controller::get_all_routers),
            )
            .route(
                "/user",
                web::get().to(crate::controllers::router_controller::get_summary_by_user_id),
            )
            .route(
                "/current",
                web::get().to(crate::controllers::router_controller::get_current_summary),
            )
            .route(
                "/role",
                web::get().to(crate::controllers::router_controller::get_summary_by_role_id),
            ),
    );
}
