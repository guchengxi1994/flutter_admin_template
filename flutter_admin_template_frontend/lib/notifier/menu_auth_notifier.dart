import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/apis.dart';
import 'package:flutter_admin_template_frontend/common/dio_utils.dart';
import 'package:flutter_admin_template_frontend/common/smart_dialog_utils.dart';
import 'package:flutter_admin_template_frontend/routers.dart';

import 'models/menu_auth_response.dart';

class MenuAuthNotifier extends ChangeNotifier {
  final Set<String> _auth = {};
  final DioUtils dioUtils = DioUtils();

  String currentRouter = "/main/dashboard";
  changeRouter(String router) {
    debugPrint(
        "[flutter] call navigation: before :$currentRouter ,after $router");
    if (currentRouter != router) {
      currentRouter = router;
      FatRouters.navigatorKey.currentState!
          .pushNamedAndRemoveUntil(router, (v) => false);
    }
  }

  changeRouterNoNavigation(String router) {
    if (currentRouter != router) {
      currentRouter = router;
      notifyListeners();
    }
  }

  refresh() async {
    Response? r = await dioUtils.get(apiDetails["currentRouters"]);

    if (r != null) {
      if (r.data['code'] != httpCodeOK) {
        SmartDialogUtils.error(r.data['message'].toString());
        return;
      }

      MenuAuthResponse menuAuthResponse =
          MenuAuthResponse.fromJson(r.data['data']);

      for (final i in menuAuthResponse.records!) {
        _auth.add(i.router ?? "");
      }
      notifyListeners();
    } else {
      SmartDialogUtils.error("未知错误");
    }
  }

  List<ValueNotifier<bool>> subVisibles = List.filled(1, ValueNotifier(false));

  collapseAll() {
    for (final i in subVisibles) {
      i.value = false;
    }
  }

  bool inSet(String i) {
    return _auth.contains(i);
  }
}
