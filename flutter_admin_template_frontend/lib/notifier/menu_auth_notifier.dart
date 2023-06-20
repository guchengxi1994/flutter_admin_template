import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/routers.dart';

class MenuAuthNotifier extends ChangeNotifier {
  final Set<String> _auth = {};

  String currentRouter = "/main/dashboard";
  changeRouter(String router) {
    if (currentRouter != router) {
      currentRouter = router;
      FatRouters.navigatorKey.currentState!.pushNamed(router);
    }
  }

  changeRouterNoNavigation(String router) {
    if (currentRouter != router) {
      currentRouter = router;
      notifyListeners();
    }
  }

  init() async {
    // for test
    _auth.add("/main/dashboard");
    _auth.add("/main/user");
    _auth.add("/main/menu");
    _auth.add("/main/dept");
    _auth.add("/main/logs");
    _auth.add("/main/logs/operation");
    _auth.add("/main/logs/signin");
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
