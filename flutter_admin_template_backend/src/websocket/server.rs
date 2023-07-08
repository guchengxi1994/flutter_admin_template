use std::{collections::HashMap, sync::RwLock};

use actix::{Actor, Context, Handler, Recipient};
use redis::Commands;

use crate::database::init::REDIS_CLIENT;

use super::message::{Connect, Disconnect, UpdateRoleMessage, WsMessage};
use lazy_static::lazy_static;

type Socket = Recipient<WsMessage>;

pub struct Server {
    pub sessions: HashMap<String, Socket>,
    // token, userid
    pub clients: HashMap<String, (i64, i64)>,
}

lazy_static! {
    static ref WS_SERVER: RwLock<Server> = RwLock::new(Server::default());
}

impl Default for Server {
    fn default() -> Self {
        Self {
            sessions: HashMap::new(),
            clients: HashMap::new(),
        }
    }
}

/// example
///
/// pub async fn xxx(...,srv: Data<Addr<Server>>){
///     let _ = srv.send(crate::websocket::message::ClientActorMessage {
///       token: "11111".into(),
///       msg: "aaaa".into(),
///    }).await;
/// }
impl Server {
    pub fn send_message(&self, message: &str, token: String) {
        let ws_server = WS_SERVER.read();
        if let Ok(_ws) = ws_server {
            if _ws.clients.contains_key(&token) {
                if let Some(r) = _ws.sessions.get(&token) {
                    r.do_send(WsMessage(message.to_owned()));
                } else {
                    println!("attempting to send message but couldn't find [session].");
                }
            } else {
                println!("attempting to send message but couldn't find [token].");
            }
        } else {
            println!("read server failed.");
        }
    }

    pub fn send_update_role_message(&self, message: &str, role_id: i64) {
        let ws_server = WS_SERVER.read();

        if let Ok(_ws) = ws_server {
            for (k, v) in &_ws.clients {
                if v.1 == role_id {
                    if let Some(r) = _ws.sessions.get(k) {
                        r.do_send(WsMessage(message.to_owned()));
                        let client = REDIS_CLIENT.lock().unwrap().clone().unwrap();
                        let mut con = client.get_connection().unwrap();
                        // redis::Commands::del(&mut con, k);
                        let _: () = con.del(k.to_string()).unwrap();
                    }
                }
            }
        } else {
            println!("read server failed.");
        }
    }
}

impl Actor for Server {
    type Context = Context<Self>;
}

impl Handler<Disconnect> for Server {
    type Result = ();

    fn handle(&mut self, msg: Disconnect, _ctx: &mut Self::Context) -> Self::Result {
        {
            let mut ws = WS_SERVER.write().unwrap();
            ws.clients.remove(&msg.token);
            ws.sessions.remove(&msg.token.clone());
        }
    }
}

impl Handler<Connect> for Server {
    type Result = ();

    fn handle(&mut self, msg: Connect, _ctx: &mut Self::Context) -> Self::Result {
        {
            let mut ws = WS_SERVER.write().unwrap();
            ws.clients.insert(msg.token.clone(), msg.user_info);
            ws.sessions.insert(msg.token.clone(), msg.addr.clone());
        }
        self.send_message(&"connected", msg.token);
    }
}

impl Handler<UpdateRoleMessage> for Server {
    type Result = ();

    fn handle(&mut self, msg: UpdateRoleMessage, _: &mut Self::Context) -> Self::Result {
        self.send_update_role_message(&msg.msg, msg.role_id);
    }
}
