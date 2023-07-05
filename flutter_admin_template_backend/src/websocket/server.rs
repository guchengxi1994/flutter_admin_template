use std::{
    collections::{HashMap, HashSet},
    sync::RwLock,
};

use actix::{Actor, Context, Handler, Recipient};

use super::message::{ClientActorMessage, Connect, Disconnect, WsMessage};
use lazy_static::lazy_static;

type Socket = Recipient<WsMessage>;

pub struct Server {
    pub sessions: HashMap<String, Socket>,
    pub clients: HashSet<String>,
}

lazy_static! {
    static ref WS_SERVER: RwLock<Server> = RwLock::new(Server::default());
}

impl Default for Server {
    fn default() -> Self {
        Self {
            sessions: HashMap::new(),
            clients: HashSet::new(),
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
            if _ws.clients.contains(&token) {
                if let Some(r) = _ws.sessions.get(&token) {
                    r.do_send(WsMessage(message.to_owned()));
                } else {
                    println!("attempting to send message but couldn't find [session].");
                }
            } else {
                println!("attempting to send message but couldn't find [token].");
            }
        }else{
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
            ws.clients.insert(msg.token.clone());
            ws.sessions.insert(msg.token.clone(), msg.addr.clone());
        }
        self.send_message(&"connected", msg.token);
    }
}

impl Handler<ClientActorMessage> for Server {
    type Result = ();

    fn handle(&mut self, msg: ClientActorMessage, _: &mut Self::Context) -> Self::Result {
        self.send_message(&msg.msg, msg.token);
    }
}


