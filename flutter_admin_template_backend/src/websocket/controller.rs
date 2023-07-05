use std::time::Instant;

use actix::Addr;
use actix_web::{
    get, web,
    web::{Data, Path},
    HttpRequest, HttpResponse,
};

use crate::{
    common::base_response::BaseResponse,
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
    let conn = WsConnection {
        token: token.token.clone(),
        addr: srv.get_ref().clone(),
        hb:Instant::now()
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
