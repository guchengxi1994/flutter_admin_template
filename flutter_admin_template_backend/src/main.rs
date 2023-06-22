use actix_web::{dev::Service, middleware::Logger, App, HttpServer};

mod common;
mod constants;
mod controllers;
mod database;
mod middleware;
mod models;
mod routers;
mod services;

#[tokio::main]
async fn main() -> std::io::Result<()> {
    crate::database::init::init_database_from_config_file("./db_config.toml").await;

    std::env::set_var("RUST_LOG", "actix_web=info");
    env_logger::init();

    HttpServer::new(|| {
        // let cors = actix_cors::Cors::default()
        //     .allow_any_header()
        //     .allow_any_method()
        //     .allow_any_origin()
        //     .send_wildcard();
        let cors = actix_cors::Cors::permissive();

        App::new()
            .wrap(cors)
            .wrap_fn(|req, srv| {
                println!("Hi from server. You requested: {}", req.path());
                srv.call(req)
            })
            .wrap(Logger::default())
            .wrap(crate::middleware::auth::Auth)
            .wrap(crate::middleware::refresh_token::RefreshToken)
            .configure(crate::routers::user::user_group)
            .configure(crate::routers::log::log_group)
    })
    .bind("0.0.0.0:15234")?
    .run()
    .await
}
