import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/apis.dart';
import 'package:flutter_admin_template_frontend/common/dio_utils.dart';
import 'package:flutter_admin_template_frontend/common/smart_dialog_utils.dart';
import 'package:flutter_admin_template_frontend/log/models/log_summary_response.dart';

class LogSummaryNotifier extends ChangeNotifier {
  final DioUtils dioUtils = DioUtils();
  List<SignIn> signIns = [];
  List<UserSignIn> userSignIns = [];

  init() async {
    String url = apiDetails["logSummary"]!;
    Response? r = await dioUtils.get(url);
    if (r != null) {
      if (r.data['code'] != httpCodeOK) {
        SmartDialogUtils.error(r.data['message'].toString());
      } else {
        SignInLogSummary summary = SignInLogSummary.fromJson(r.data['data']);
        // print(summary.toJson());
        signIns = summary.signIn ?? [];
        userSignIns = summary.userSignIn ?? [];
        notifyListeners();
      }
    }
  }
}
