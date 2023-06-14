use actix_web::{dev::Service, middleware::Logger, App, HttpServer};

mod common;
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
        App::new()
            .wrap_fn(|req, srv| {
                println!("Hi from server. You requested: {}", req.path());
                srv.call(req)
            })
            .wrap(Logger::default())
            .wrap(crate::middleware::auth::Auth)
            .wrap(crate::middleware::refresh_token::RefreshToken)
            .configure(crate::routers::user::user_group)
            .configure(crate::routers::user_login::user_login_group)
    })
    .bind("127.0.0.1:15234")?
    .run()
    .await
}
