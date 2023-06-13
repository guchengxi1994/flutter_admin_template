use actix_web::{dev::Service, web, App, HttpServer};

mod common;
mod controllers;
mod database;
mod middleware;
mod models;
mod routers;
mod services;

#[derive(Debug, serde::Deserialize)]
struct Params {
    token: String,
}

#[tokio::main]
async fn main() -> std::io::Result<()> {
    crate::database::init::init_database_from_config_file("./db_config.toml").await;

    HttpServer::new(|| {
        App::new()
            .wrap_fn(|req, srv| {
                println!("Hi from server. You requested: {}", req.path());
                srv.call(req)
            })
            .wrap_fn(|req, srv| {
                println!("Hi from response");
                let auth = web::Query::<Params>::from_query(req.query_string());
                match auth {
                    Ok(_auth) => {
                        let id =
                            crate::database::validate_token::validate_token(_auth.0.token.clone());
                        match id {
                            Ok(id) => {
                                println!("{:?}", id)
                            }
                            Err(_) => {
                                println!(" {:?} Token not valid", _auth.0.token)
                            }
                        }
                    }
                    Err(_) => {
                        println!("Authorization Not Found")
                    }
                }
                srv.call(req)
            })
            .configure(crate::routers::user::user_group)
    })
    .bind("127.0.0.1:15234")?
    .run()
    .await
}
