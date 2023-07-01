import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/apis.dart';
import 'package:flutter_admin_template_frontend/common/dio_utils.dart';
import 'package:flutter_admin_template_frontend/common/local_storage.dart';
import 'package:flutter_admin_template_frontend/common/smart_dialog_utils.dart';
import 'package:flutter_admin_template_frontend/routers.dart';

import 'models/menu_auth_response.dart' as menu;
import 'models/all_router_response.dart' as router;

class MenuAuthNotifier extends ChangeNotifier {
  final Set<String> _auth = {};
  final DioUtils dioUtils = DioUtils();
  final FatLocalStorage storage = FatLocalStorage();

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

  Future<List<router.Records>> getAll() async {
    Response? r = await dioUtils.get(apiDetails["allRouters"]);

    if (r != null) {
      if (r.data['code'] != httpCodeOK) {
        SmartDialogUtils.error(r.data['message'].toString());
      }

      router.AllRouterResponse allRouterResponse =
          router.AllRouterResponse.fromJson(r.data['data']);
      return allRouterResponse.records ?? [];
    }

    return [];
  }

  refresh() async {
    Response? r = await dioUtils.get(apiDetails["currentRouters"]);

    if (r != null) {
      if (r.data['code'] != httpCodeOK) {
        SmartDialogUtils.error(r.data['message'].toString());
        return;
      }

      menu.MenuAuthResponse menuAuthResponse =
          menu.MenuAuthResponse.fromJson(r.data['data']);

      for (final i in menuAuthResponse.records!) {
        _auth.add(i.router ?? "");
      }
      await storage.setMenuAuth(_auth.toList());
    } else {
      SmartDialogUtils.error("未知错误");
    }
  }

  Future<List<String>> loadCache() async {
    var s = await storage.getMenuAuth();
    if (s.isEmpty) {
      await refresh();
      return _auth.toList();
    }
    return s;
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
