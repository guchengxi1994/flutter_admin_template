import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu_auth_notifier.dart';
import 'router_auth_notifier.dart';
import 'widget_auth_notifier.dart';

final menuAuthProvider = ChangeNotifierProvider<MenuAuthNotifier>((ref) {
  return MenuAuthNotifier()..init();
});

final routerAuthProvider = ChangeNotifierProvider<RouterAuthNotifier>((ref) {
  return RouterAuthNotifier()..init();
});

final widgetAuthProvider = ChangeNotifierProvider<WidgetAuthNotifier>((ref) {
  return WidgetAuthNotifier()..init();
});
