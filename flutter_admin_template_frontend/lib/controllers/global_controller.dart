import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu_auth_controller.dart';
import 'router_auth_controller.dart';
import 'widget_auth_controller.dart';

final menuAuthProvider = ChangeNotifierProvider<MenuAuthController>((ref) {
  return MenuAuthController()..init();
});

final routerAuthProvider = ChangeNotifierProvider<RouterAuthController>((ref) {
  return RouterAuthController()..init();
});

final widgetAuthProvider = ChangeNotifierProvider<WidgetAuthController>((ref) {
  return WidgetAuthController()..init();
});
