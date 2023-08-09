use actix::prelude::{Message, Recipient};

#[derive(Message)]
#[rtype(result = "()")]
pub struct WsMessage(pub String);

#[derive(Message)]
#[rtype(result = "()")]
pub struct Connect {
    pub addr: Recipient<WsMessage>,
    pub token: String,
    // user id ; role id
    pub user_info: (i64, i64),
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct Disconnect {
    pub token: String,
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct UpdateRoleMessage {
    pub msg: String,
    pub role_id: i64,
}
