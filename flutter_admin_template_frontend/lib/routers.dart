import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/dashboard/dashboard_screen.dart'
    deferred as dashboard;
import 'package:flutter_admin_template_frontend/dept/dept_screen.dart'
    deferred as dept;
import 'package:flutter_admin_template_frontend/menu/menu_screen.dart'
    deferred as menu;
import 'package:flutter_admin_template_frontend/role/role_screen.dart'
    deferred as role;
import 'package:flutter_admin_template_frontend/user/user_screen.dart'
    deferred as user;
import 'package:flutter_admin_template_frontend/log/log_summary_screen.dart'
    deferred as log;
import 'package:flutter_admin_template_frontend/log/sign_in_log_screen.dart'
    deferred as signin;
import 'package:flutter_admin_template_frontend/log/operation_log_screen.dart'
    deferred as operation;

import 'common/future_builder.dart';
import 'login/login_screen.dart' deferred as login;
import 'layout/layout.dart';

class FatRouters {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static String dashboardScreen = "/main/dashboard";
  static String userScreen = "/main/user";
  static String menuScreen = "/main/menu";
  static String deptScreen = "/main/dept";
  static String loginScreen = "/loginScreen";
  static String roleScreen = "/main/role";
  static String logScreen = "/main/logs";
  static String operationLogScreen = "/main/logs/operation";
  static String signInLogScreen = "/main/logs/signin";

  static Map<String, WidgetBuilder> routers = {
    dashboardScreen: (context) => Layout(
        body: FutureLoaderWidget(
            builder: (context) => dashboard.DashboardScreen(),
            loadWidgetFuture: dashboard.loadLibrary())),
    userScreen: (context) => Layout(
        body: FutureLoaderWidget(
            builder: (context) => user.UserScreen(),
            loadWidgetFuture: user.loadLibrary())),
    deptScreen: (context) => Layout(
        body: FutureLoaderWidget(
            builder: (context) => dept.DeptScreen(),
            loadWidgetFuture: dept.loadLibrary())),
    menuScreen: (context) => Layout(
        body: FutureLoaderWidget(
            builder: (context) => menu.MenuScreen(),
            loadWidgetFuture: menu.loadLibrary())),
    roleScreen: (context) => Layout(
        body: FutureLoaderWidget(
            builder: (context) => role.RoleScreen(),
            loadWidgetFuture: role.loadLibrary())),
    logScreen: (context) => Layout(
        body: FutureLoaderWidget(
            builder: (context) => log.LogSummaryScreen(),
            loadWidgetFuture: log.loadLibrary())),
    operationLogScreen: (context) => Layout(
        body: FutureLoaderWidget(
            builder: (context) => operation.OperationLogScreen(),
            loadWidgetFuture: operation.loadLibrary())),
    signInLogScreen: (context) => Layout(
        body: FutureLoaderWidget(
            builder: (context) => signin.SignInLogScreen(),
            loadWidgetFuture: signin.loadLibrary())),
    loginScreen: (context) => FutureLoaderWidget(
        builder: (context) => login.LoginScreen(),
        loadWidgetFuture: login.loadLibrary())
  };
}
