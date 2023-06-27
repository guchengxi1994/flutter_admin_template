class SignInLogSummary {
  List<SignIn>? signIn;
  List<UserSignIn>? userSignIn;

  SignInLogSummary({this.signIn, this.userSignIn});

  SignInLogSummary.fromJson(Map<String, dynamic> json) {
    if (json['signIn'] != null) {
      signIn = <SignIn>[];
      json['signIn'].forEach((v) {
        signIn!.add(SignIn.fromJson(v));
      });
    }
    if (json['userSignIn'] != null) {
      userSignIn = <UserSignIn>[];
      json['userSignIn'].forEach((v) {
        userSignIn!.add(UserSignIn.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (signIn != null) {
      data['signIn'] = signIn!.map((v) => v.toJson()).toList();
    }
    if (userSignIn != null) {
      data['userSignIn'] = userSignIn!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SignIn {
  int? count;
  String? loginState;

  SignIn({this.count, this.loginState});

  SignIn.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    loginState = json['loginState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['loginState'] = loginState;
    return data;
  }
}

class UserSignIn {
  int? count;
  String? userName;

  UserSignIn({this.count, this.userName});

  UserSignIn.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['userName'] = userName;
    return data;
  }
}
