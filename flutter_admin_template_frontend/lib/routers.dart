import 'package:flutter/material.dart';

import 'common/future_builder.dart';
import 'login/login_screen.dart' deferred as login;
import 'layout/layout.dart' deferred as layout;

class FatRouters {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static String mainScreen = "/main";
  static String loginScreen = "/loginScreen";

  static Map<String, WidgetBuilder> routers = {
    mainScreen: (context) => FutureLoaderWidget(
        builder: (context) => layout.Layout(),
        loadWidgetFuture: layout.loadLibrary()),
    loginScreen: (context) => FutureLoaderWidget(
        builder: (context) => login.LoginScreen(),
        loadWidgetFuture: login.loadLibrary())
  };
}
