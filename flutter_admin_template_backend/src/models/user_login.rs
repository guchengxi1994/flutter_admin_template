use std::fmt::Display;

use sqlx::types::chrono;

pub enum LoginState {
    Success,
    NoUser,
    ErrPwd,
}

impl Display for LoginState {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            LoginState::Success => {
                write!(f, "success")
            }
            LoginState::NoUser => {
                write!(f, "no user")
            }
            LoginState::ErrPwd => {
                write!(f, "error password")
            }
        }
    }
}

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct UserLogin {
    pub login_id: i64,
    pub user_id: i64,
    pub login_ip: String,
    pub login_time: chrono::DateTime<chrono::Local>,
    pub login_state: String,
    pub user_name: String,
}
