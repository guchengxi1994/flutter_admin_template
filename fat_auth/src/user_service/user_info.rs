use std::fmt::Display;

pub struct UserLoginInfo {
    pub username: String,
    pub password: String,
}

pub struct UserInfo {
    pub user_id: Option<i64>,
    pub token: Option<String>,
}

impl Display for UserInfo {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "UserInfo : user_id: {:?}, token: {:?}",
            self.user_id, self.token
        )
    }
}

pub trait UserInfoTrait {}
