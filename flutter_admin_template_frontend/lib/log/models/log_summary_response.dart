class SignInLogSummary {
  List<SignIn>? signIn;

  SignInLogSummary({this.signIn});

  SignInLogSummary.fromJson(Map<String, dynamic> json) {
    if (json['signIn'] != null) {
      signIn = <SignIn>[];
      json['signIn'].forEach((v) {
        signIn!.add(SignIn.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (signIn != null) {
      data['signIn'] = signIn!.map((v) => v.toJson()).toList();
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
