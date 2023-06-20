class LoginRequest {
  String? userName;
  String? password;

  LoginRequest({this.userName, this.password});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_name'] = userName;
    data['password'] = password;
    return data;
  }
}
