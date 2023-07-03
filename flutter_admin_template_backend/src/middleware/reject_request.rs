// 同一个接口 同一个IP 一段时间 重复访问 被拦截
// 10 秒 不能超过 3次

use crate::common::base_response::BaseResponse;
use crate::constants::REJECT_TIMES;
use crate::database::init::REDIS_CLIENT;
use std::future::{ready, Ready};

use actix_web::body::EitherBody;
use actix_web::HttpResponse;
use actix_web::{
    dev::{forward_ready, Service, ServiceRequest, ServiceResponse, Transform},
    Error,
};
use futures_util::future::LocalBoxFuture;

pub struct RejectRequest;

impl<S, B> Transform<S, ServiceRequest> for RejectRequest
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<EitherBody<B>>;
    type Error = Error;
    type InitError = ();
    type Transform = RejectRequestMiddleware<S>;
    type Future = Ready<Result<Self::Transform, Self::InitError>>;

    fn new_transform(&self, service: S) -> Self::Future {
        ready(Ok(RejectRequestMiddleware { service }))
    }
}

pub struct RejectRequestMiddleware<S> {
    service: S,
}

impl<S, B> Service<ServiceRequest> for RejectRequestMiddleware<S>
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
        let ip = req.peer_addr();
        if let Some(_ip) = ip {
            let path = req.path().to_string();
            let client = REDIS_CLIENT.lock().unwrap().clone().unwrap();
            let mut con = client.get_connection().unwrap();
            let s = format!("{:?}_{:?}", _ip.ip().to_string(), path);

            let times = super::get_reject_times(s.clone(), &mut con);
            if let Ok(t) = times {
                if t >= *REJECT_TIMES.lock().unwrap() {
                    // 拦截
                    let b: BaseResponse<Option<String>> = BaseResponse {
                        code: crate::constants::BAD_REQUEST,
                        message: "同时访问多次",
                        data: None,
                    };

                    let res = req
                        .into_response(HttpResponse::Ok().json(&b))
                        .map_into_right_body();
                    return Box::pin(async { Ok(res) });
                } else {
                    let r = super::times_add_one(s, &mut con);
                    match r {
                        Ok(_) => {}
                        Err(e) => {
                            println!("[rust] error : {:?}", e);
                        }
                    }
                }
            } else {
                let r = super::set_first_time(s, &mut con);
                match r {
                    Ok(_) => {}
                    Err(e) => {
                        println!("[rust] error : {:?}", e);
                        let b: BaseResponse<Option<String>> = BaseResponse {
                            code: crate::constants::BAD_REQUEST,
                            message: "访问异常",
                            data: None,
                        };

                        let res = req
                            .into_response(HttpResponse::Ok().json(&b))
                            .map_into_right_body();
                        return Box::pin(async { Ok(res) });
                    }
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
