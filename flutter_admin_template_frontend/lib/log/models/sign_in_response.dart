class SigninResponse {
  int? count;
  List<Records>? data;

  SigninResponse({this.count, this.data});

  SigninResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <Records>[];
      json['data'].forEach((v) {
        data!.add(Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Records {
  int? loginId;
  int? userId;
  String? loginIp;
  String? loginTime;
  String? loginState;
  String? userName;

  Records(
      {this.loginId,
      this.userId,
      this.loginIp,
      this.loginTime,
      this.loginState,
      this.userName});

  Records.fromJson(Map<String, dynamic> json) {
    loginId = json['loginId'];
    userId = json['userId'];
    loginIp = json['loginIp'];
    loginTime = json['loginTime'];
    loginState = json['loginState'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loginId'] = loginId;
    data['userId'] = userId;
    data['loginIp'] = loginIp;
    data['loginTime'] = loginTime;
    data['loginState'] = loginState;
    data['userName'] = userName;
    return data;
  }
}
