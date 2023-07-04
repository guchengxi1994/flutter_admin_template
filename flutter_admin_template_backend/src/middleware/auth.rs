use crate::common::base_response::BaseResponse;
use std::future::{ready, Ready};

use actix_web::{
    body::EitherBody,
    dev::{forward_ready, Service, ServiceRequest, ServiceResponse, Transform},
    web, Error, HttpMessage, HttpResponse,
};
use futures_util::future::LocalBoxFuture;

// There are two steps in middleware processing.
// 1. Middleware initialization, middleware factory gets called with
//    next service in chain as parameter.
// 2. Middleware's call method gets called with normal request.
pub struct Auth;

// Middleware factory is `Transform` trait
// `S` - type of the next service
// `B` - type of response's body
impl<S, B> Transform<S, ServiceRequest> for Auth
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<EitherBody<B>>;
    type Error = Error;
    type InitError = ();
    type Transform = AuthMiddleware<S>;
    type Future = Ready<Result<Self::Transform, Self::InitError>>;

    fn new_transform(&self, service: S) -> Self::Future {
        ready(Ok(AuthMiddleware { service }))
    }
}

pub struct AuthMiddleware<S> {
    service: S,
}

#[derive(Debug, serde::Deserialize)]
struct Params {
    token: String,
}

impl<S, B> Service<ServiceRequest> for AuthMiddleware<S>
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<EitherBody<B>>;
    type Error = Error;
    type Future = LocalBoxFuture<'static, Result<Self::Response, Self::Error>>;

    forward_ready!(service);

    fn call(&self, req: ServiceRequest) -> Self::Future {
        println!("[rust] current query :{:?}", req.path().to_string());

        if req.path().to_string() != "/system/user/login" {
            let auth = web::Query::<Params>::from_query(req.query_string());
            match auth {
                Ok(_auth) => {
                    let id = crate::database::validate_token::validate_token(_auth.0.token.clone());
                    match id {
                        Ok(id) => {
                            req.extensions_mut().insert(super::UserId { user_id: id });
                            println!("current_user_id ==> {:?}", id);
                            // 判断 api 可不可以访问

                            let can_visit = crate::database::get_api_auth::can_api_be_visited(
                                req.path().to_string(),
                                _auth.0.token.clone(),
                            );
                            if !can_visit {
                                println!(" {:?} 无权访问这个接口", req.path().to_string());
                                let b: BaseResponse<Option<String>> = BaseResponse {
                                    code: crate::constants::NO_AUTH,
                                    message: "无权访问这个接口",
                                    data: None,
                                };
                                let res = req
                                    .into_response(HttpResponse::Ok().json(&b))
                                    .map_into_right_body();
                                return Box::pin(async { Ok(res) });
                            }
                        }
                        Err(_) => {
                            println!(" {:?} Token not valid", _auth.0.token);
                            let b: BaseResponse<Option<String>> = BaseResponse {
                                code: crate::constants::INVALID_TOKEN,
                                message: "Token not valid",
                                data: None,
                            };

                            let res = req
                                .into_response(HttpResponse::Ok().json(&b))
                                .map_into_right_body();
                            return Box::pin(async { Ok(res) });
                        }
                    }
                }
                Err(_) => {
                    println!("Authorization Not Found");
                    let b: BaseResponse<Option<String>> = BaseResponse {
                        code: crate::constants::INVALID_USER,
                        message: "Authorization Not Found",
                        data: None,
                    };

                    let res = req
                        .into_response(HttpResponse::Ok().json(&b))
                        .map_into_right_body();
                    return Box::pin(async { Ok(res) });
                }
            }
        }

        let fut = self.service.call(req);

        Box::pin(async move {
            let res = fut.await?.map_into_left_body();

            Ok(res)
        })
    }
}
