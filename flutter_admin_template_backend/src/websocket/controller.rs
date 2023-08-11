use std::time::Instant;

use actix::Addr;
use actix_web::{
    get, web,
    web::{Data, Path},
    HttpRequest, HttpResponse,
};

use crate::{
    common::base_response::BaseResponse,
    database::init::POOL,
    services::role_service::RoleTrait,
    websocket::{connection::WsConnection, server::Server},
};

#[derive(serde::Deserialize)]
struct Token {
    token: String,
}

/// ws://localhost:15234/ws
#[get("/ws/{token}")]
async fn websocket(
    req: HttpRequest,
    stream: web::Payload,
    token: Path<Token>,
    srv: Data<Addr<Server>>,
) -> HttpResponse {
    println!("token : {:?}", token.token.clone());
    let pool = POOL.lock().await;
    let id = crate::database::validate_token::validate_token(token.token.clone()).unwrap_or(0);
    let role_id =
        crate::services::role_service::RoleService::get_role_id_by_user_id(id, pool.get_pool())
            .await;

    let mut _role_id: i64;
    match role_id {
        Ok(_r) => {
            _role_id = _r.unwrap_or(0);
        }
        Err(_) => _role_id = 0,
    };

    let conn = WsConnection {
        token: token.token.clone(),
        addr: srv.get_ref().clone(),
        hb: Instant::now(),
        user_id: id,
        role_id: _role_id,
    };
    let resp = actix_web_actors::ws::start(conn, &req, stream);
    match resp {
        Ok(ret) => {
            return ret;
        }
        Err(e) => {
            println!("[rust error] : {:?}", e);
            // return e.error_response();
            let b: BaseResponse<Option<String>> = BaseResponse {
                code: crate::constants::WS_CONNECTION_ERR,
                message: "无法连接ws",
                data: None,
            };

            return HttpResponse::Ok().json(&b);
        }
    }
}
