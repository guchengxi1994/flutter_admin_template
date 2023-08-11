use std::fmt::Display;

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

pub trait UserInfoTrait {
    fn new(user_id: Option<i64>, token: Option<String>) -> Self;
}

impl UserInfoTrait for UserInfo {
    fn new(user_id: Option<i64>, token: Option<String>) -> Self {
        UserInfo { user_id, token }
    }
}
