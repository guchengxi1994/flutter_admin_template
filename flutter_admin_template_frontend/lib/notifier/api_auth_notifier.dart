import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/apis.dart';
import 'package:flutter_admin_template_frontend/common/dio_utils.dart';
import 'package:flutter_admin_template_frontend/common/local_storage.dart';
import 'package:flutter_admin_template_frontend/common/smart_dialog_utils.dart';

import 'models/api_response.dart';

class ApiAuthNotifier extends ChangeNotifier {
  final Set<String> _auth = {};
  final DioUtils dioUtils = DioUtils();
  final FatLocalStorage storage = FatLocalStorage();

  init() async {
    Response? r = await dioUtils.get(apiDetails["getApiCurrent"]);

    if (r != null) {
      if (r.data['code'] != httpCodeOK) {
        SmartDialogUtils.error(r.data['message'].toString());
        return;
      }

      ApiResponse authResponse = ApiResponse.fromJson(r.data['data']);

      for (final i in authResponse.records!) {
        _auth.add(i.apiRouter ?? "");
      }
      await storage.setApiAuth(_auth.toList());
    } else {
      SmartDialogUtils.error("未知错误");
    }
  }

  refresh() async {
    await init();
  }

  Future<List<String>> get apiAuths async => await storage.getApiAuth();

  @Deprecated("unused")
  bool inSet(String i) {
    return _auth.contains(i);
  }
}
