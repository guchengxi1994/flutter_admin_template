import 'dart:convert';

import 'package:flutter_admin_template_frontend/apis.dart';
import 'package:flutter_admin_template_frontend/table/base_request.dart';
import 'package:flutter_admin_template_frontend/table/base_table_notifier.dart';

import '../models/sign_in_response.dart';

class SignInLogNotifier extends BaseTableNotifier {
  @override
  init(String url, String method, {BaseRequest? request}) async {
    String url = "${apiDetails["signinlog"]!}?pageNumber=1&pageSize=10";
    return super.init(url, "get", request: null);
  }

  @override
  List<Records> get records => _convertListToRecord();

  Records? _convertStringToRecord(dynamic s) {
    try {
      final Map<String, dynamic> m;
      if (s is String) {
        m = jsonDecode(s);
      } else if (s is Map) {
        m = s as Map<String, dynamic>;
      } else {
        m = {};
        throw Exception("[flutter] cannot read content");
      }

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

  @override
  onPageIndexChange(int index, String url,
      {Map<String, dynamic> parameters = const {}}) async {
    url = "${apiDetails["signinlog"]!}?pageNumber=$index&pageSize=10";
    for (final i in parameters.entries) {
      if (i.value != null) {
        url = "$url&${i.key}=${i.value}";
      }
    }

    return super.onPageIndexChange(index, url, parameters: parameters);
  }

  @override
  onReset(String url, String method, {BaseRequest? request}) {
    String url = "${apiDetails["signinlog"]!}?pageNumber=1&pageSize=10";
    return super.onReset(url, "get", request: null);
  }

  @override
  onSubmit(String url, DateTime? first, DateTime? last, String? status,
      String? keyword, bool b) {
    currentIndex = 1;
    String url =
        "${apiDetails["signinlog"]!}?pageNumber=$currentIndex&pageSize=10";
    if (b) {
      int startTime = first!.millisecondsSinceEpoch ~/ 1000;
      int endTime = last!.millisecondsSinceEpoch ~/ 1000;
      url = "$url&startTime=$startTime&endTime=$endTime";
    }
    if (keyword != null && keyword.trim() != "") {
      url = "$url&username=$keyword";
    }
    if (status != null) {
      url = "$url&state=$status";
    }

    return super.onSubmit(url, null, null, null, null, b);
  }
}
