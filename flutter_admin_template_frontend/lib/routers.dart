import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/dashboard/dashboard_screen.dart'
    deferred as dashboard;
import 'package:flutter_admin_template_frontend/log/log_screen.dart'
    deferred as log;
import 'package:flutter_admin_template_frontend/log/sign_in_log_screen.dart'
    deferred as signin;
import 'package:flutter_admin_template_frontend/log/operation_log_screen.dart'
    deferred as operation;
import 'package:flutter_admin_template_frontend/sys_management/sys_management_screen.dart'
    as sys_management;

import 'common/future_builder.dart';
import 'layout/layout_v2.dart';
import 'signin/login_screen.dart' deferred as login;

class FatRouters {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static String dashboardScreen = "/main/dashboard";
  static String userScreen = "/main/user";
  static String menuScreen = "/main/menu";
  static String deptScreen = "/main/dept";
  static String loginScreen = "/loginScreen";
  static String roleScreen = "/main/role";
  static String logScreen = "/main/logs";
  static String sysManagement = "/main/sys_management";
  static String operationLogScreen = "/main/logs/operation";
  static String signInLogScreen = "/main/logs/signin";

  static Map<String, WidgetBuilder> routers = {
    dashboardScreen: (context) => LayoutV2(
        body: FutureLoaderWidget(
            builder: (context) => dashboard.DashboardScreen(),
            loadWidgetFuture: dashboard.loadLibrary())),
    // userScreen: (context) => LayoutV2(
    //     body: FutureLoaderWidget(
    //         builder: (context) => user.UserScreen(),
    //         loadWidgetFuture: user.loadLibrary())),
    // deptScreen: (context) => LayoutV2(
    //     body: FutureLoaderWidget(
    //         builder: (context) => dept.DeptScreen(),
    //         loadWidgetFuture: dept.loadLibrary())),
    // menuScreen: (context) => LayoutV2(
    //     body: FutureLoaderWidget(
    //         builder: (context) => menu.MenuScreen(),
    //         loadWidgetFuture: menu.loadLibrary())),
    // roleScreen: (context) => LayoutV2(
    //     body: FutureLoaderWidget(
    //         builder: (context) => role.RoleScreen(),
    //         loadWidgetFuture: role.loadLibrary())),
    logScreen: (context) => LayoutV2(
        body: FutureLoaderWidget(
            builder: (context) => log.LogScreen(),
            loadWidgetFuture: log.loadLibrary())),
    operationLogScreen: (context) => LayoutV2(
        body: FutureLoaderWidget(
            builder: (context) => operation.OperationLogScreen(),
            loadWidgetFuture: operation.loadLibrary())),
    signInLogScreen: (context) => LayoutV2(
        body: FutureLoaderWidget(
            builder: (context) => signin.SignInLogScreen(),
            loadWidgetFuture: signin.loadLibrary())),
    loginScreen: (context) => FutureLoaderWidget(
        builder: (context) => login.LoginScreen(),
        loadWidgetFuture: login.loadLibrary()),
    sysManagement: (context) =>
        const LayoutV2(body: sys_management.SysManagementScreen())
  };
}
