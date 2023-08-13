use crate::common::base_response::BaseResponse;
use crate::controllers::department_controller;
use actix_web::{error, web, HttpResponse};

pub fn dept_group(config: &mut web::ServiceConfig) {
    config.service(
        web::scope("/system/dept")
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
                "/tree",
                web::get().to(department_controller::get_department_tree),
            )
            .route(
                "/tree/without",
                web::get().to(department_controller::get_department_tree_without),
            )
            .route(
                "/query",
                web::get().to(department_controller::get_dept_by_id),
            )
            .route(
                "/query/single",
                web::get().to(department_controller::get_single_dept_details),
            )
            .route("/new", web::post().to(department_controller::new_dept))
            .route(
                "/update",
                web::post().to(department_controller::update_dept),
            ),
    );
}
