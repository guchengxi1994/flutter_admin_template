use actix::prelude::{Message, Recipient};

#[derive(Message)]
#[rtype(result = "()")]
pub struct WsMessage(pub String);

#[derive(Message)]
#[rtype(result = "()")]
pub struct Connect {
    pub addr: Recipient<WsMessage>,
    pub token: String,
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct Disconnect {
    pub token: String,
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct ClientActorMessage {
    pub token: String,
    pub msg: String,
}