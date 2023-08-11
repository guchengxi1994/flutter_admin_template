use crate::database::init::REDIS_CLIENT_SYNC;
use std::future::{ready, Ready};

use actix_web::{
    dev::{forward_ready, Service, ServiceRequest, ServiceResponse, Transform},
    web, Error,
};
use futures_util::future::LocalBoxFuture;

pub struct RefreshToken;

impl<S, B> Transform<S, ServiceRequest> for RefreshToken
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<B>;
    type Error = Error;
    type InitError = ();
    type Transform = RefreshTokenMiddleware<S>;
    type Future = Ready<Result<Self::Transform, Self::InitError>>;

    fn new_transform(&self, service: S) -> Self::Future {
        ready(Ok(RefreshTokenMiddleware { service }))
    }
}

pub struct RefreshTokenMiddleware<S> {
    service: S,
}

#[derive(Debug, serde::Deserialize)]
struct Params {
    token: String,
}

impl<S, B> Service<ServiceRequest> for RefreshTokenMiddleware<S>
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<B>;
    type Error = Error;
    type Future = LocalBoxFuture<'static, Result<Self::Response, Self::Error>>;

    forward_ready!(service);

    fn call(&self, req: ServiceRequest) -> Self::Future {
        if req.path().to_string() != "/system/user/login" {
            let auth = web::Query::<Params>::from_query(req.query_string());
            match auth {
                Ok(_auth) => {
                    let client = REDIS_CLIENT_SYNC.lock().unwrap().clone().unwrap();
                    let mut con = client.get_connection().unwrap();
                    let _ = crate::database::refresh_token::refresh_token(_auth.0.token, &mut con);
                }
                Err(_) => {}
            }
        }

        let fut = self.service.call(req);

        Box::pin(async move {
            let res = fut.await?;

            Ok(res)
        })
    }
}
