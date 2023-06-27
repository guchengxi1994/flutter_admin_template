use std::fmt::Display;

use sqlx::types::chrono;

pub enum SignInState {
    Success,
    NoUser,
    ErrPwd,
}

impl Display for SignInState {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            SignInState::Success => {
                write!(f, "success")
            }
            SignInState::NoUser => {
                write!(f, "no user")
            }
            SignInState::ErrPwd => {
                write!(f, "error password")
            }
        }
    }
}

#[derive(Clone, Debug, sqlx::FromRow, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct SignInRecord {
    pub login_id: i64,
    pub user_id: i64,
    pub login_ip: String,
    pub login_time: chrono::DateTime<chrono::Local>,
    pub login_state: String,
    pub user_name: String,
    #[serde(skip)]
    pub token: Option<String>,
}
