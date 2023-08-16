use actix_web::{web, HttpRequest, HttpResponse};

use crate::services::sys_config_service::{NewSysConfigRequest, UpdateSysConfigRequest};

#[derive(Debug, serde::Deserialize)]
struct QueryParams {
    pub id: i64,
}

pub async fn get_config_by_id(_req: HttpRequest) -> HttpResponse {
    todo!()
}

pub async fn delete_config_by_id(_req: HttpRequest) -> HttpResponse {
    todo!()
}

pub async fn create_config(info: web::Json<NewSysConfigRequest>) -> HttpResponse {
    todo!()
}

pub async fn update_config(info: web::Json<UpdateSysConfigRequest>) -> HttpResponse {
    todo!()
}

pub async fn get_config_list(_req: HttpRequest)->HttpResponse{
    todo!()
}
