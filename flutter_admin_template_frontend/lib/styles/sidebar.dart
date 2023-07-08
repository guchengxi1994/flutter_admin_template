part of './app_style.dart';

class _SidebarStyle {
  static const double sidebarWidth = 200;
  static const double sidebarCollapseWidth = 50;
  static Color hoveringBackgroundColor =
      const Color.fromARGB(193, 15, 84, 188).withOpacity(0.5);
  static const double sidebarHeaderHeight = 100;
}

class SidebarIcons {
  SidebarIcons._();
  static const Widget dashBoard = Icon(Icons.dashboard);
  static const Widget dashBoardOnHover =
      Icon(Icons.dashboard_outlined, color: Colors.lightBlueAccent);

  static const Widget user = Icon(Icons.people);
  static const Widget userOnHover =
      Icon(Icons.people_outline, color: Colors.lightBlueAccent);

  static const Widget dept = Icon(Icons.local_fire_department);
  static const Widget deptOnHover =
      Icon(Icons.local_fire_department_outlined, color: Colors.lightBlueAccent);

  static const Widget menu = Icon(Icons.menu);
  static const Widget menuOnHover =
      Icon(Icons.menu_outlined, color: Colors.lightBlueAccent);

  static const Widget role = Icon(Icons.ac_unit);
  static const Widget roleOnHover =
      Icon(Icons.ac_unit_outlined, color: Colors.lightBlueAccent);

  static const Widget log = Icon(Icons.details);
  static const Widget logOnHover =
      Icon(Icons.details_outlined, color: Colors.lightBlueAccent);

  static const Widget operation = Icon(Icons.change_history);
  static const Widget operationOnHover =
      Icon(Icons.change_history_outlined, color: Colors.lightBlueAccent);

  static const Widget signin = Icon(Icons.login);
  static const Widget signinOnHover =
      Icon(Icons.login_outlined, color: Colors.lightBlueAccent);

  static Widget getByRouter(String router) {
    switch (router) {
      case "/main/dashboard":
        return dashBoard;
      case "/main/user":
        return user;
      case "/main/dept":
        return dept;
      case "/main/menu":
        return menu;
      case "/main/role":
        return role;
      case "/main/logs":
        return log;
      case "/main/logs/operation":
        return operation;
      case "/main/logs/signin":
        return signin;
      case "/loginScreen":
        return const Icon(Icons.abc);
      default:
        return dashBoard;
    }
  }
}
