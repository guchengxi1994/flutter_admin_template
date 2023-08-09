use actix::Actor;
use actix_web::{middleware::Logger, web::Data, App, HttpServer};

mod common;
mod constants;
mod controllers;
mod database;
mod middleware;
mod models;
mod routers;
mod services;
mod websocket;

#[tokio::main]
async fn main() -> std::io::Result<()> {
    crate::database::init::init_from_config_file("./config.toml").await;
    let _ = crate::database::get_api_auth::init_api().await;

    std::env::set_var("RUST_LOG", "actix_web=info");
    env_logger::init();

    HttpServer::new(|| {
        let cors = actix_cors::Cors::permissive();

        let ws_server = crate::websocket::server::Server::default().start();

        App::new()
            .wrap(Logger::default())
            .wrap(crate::middleware::auth::Auth)
            .wrap(crate::middleware::refresh_token::RefreshToken)
            .wrap(crate::middleware::reject_request::RejectRequest)
            .wrap(cors)
            .configure(crate::routers::user::user_group)
            .configure(crate::routers::log::log_group)
            .configure(crate::routers::router::router_group)
            .configure(crate::routers::role::role_group)
            .configure(crate::routers::api::api_group)
            .configure(crate::routers::department::dept_group)
            .service(crate::websocket::controller::websocket)
            .app_data(Data::new(ws_server))
    })
    .bind("0.0.0.0:15234")?
    .run()
    .await
}
