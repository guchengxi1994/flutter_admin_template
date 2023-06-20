import 'dart:convert';

import 'package:flutter_admin_template_frontend/apis.dart';
import 'package:flutter_admin_template_frontend/table/base_request.dart';
import 'package:flutter_admin_template_frontend/table/base_response.dart';
import 'package:flutter_admin_template_frontend/table/base_table_notifier.dart';

import '../models/sign_in_response.dart';

class SignInLogNotifier<_ extends BaseRequest,
    SigninResponse extends BaseResponse> extends BaseTableNotifier {
  @override
  init(String url, String method, {BaseRequest? request}) async {
    String url = "${apiDetails["signinlog"]!}?pageNumber=1&pageSize=10";
    return super.init(url, "get", request: null);
  }

  @override
  List<Records> get records => _convertListToRecord();

  Records? _convertStringToRecord(String s) {
    try {
      final m = jsonDecode(s);
      return Records.fromJson(m);
    } catch (e) {
      return null;
    }
  }

  List<Records> _convertListToRecord() {
    List<Records> result = [];
    for (final i in super.records) {
      final r = _convertStringToRecord(i);
      if (r != null) {
        result.add(r);
      } else {
        result.add(Records(
            loginId: 0,
            userId: 0,
            loginIp: "ERROR",
            loginTime: "ERROR",
            loginState: "ERROR",
            userName: "ERROR"));
      }
    }
    return result;
  }
}
