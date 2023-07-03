import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu_auth_notifier.dart';
import 'api_auth_notifier.dart';
import 'widget_auth_notifier.dart';

final menuAuthProvider = ChangeNotifierProvider<MenuAuthNotifier>((ref) {
  return MenuAuthNotifier();
});

final apiAuthProvider = ChangeNotifierProvider<ApiAuthNotifier>((ref) {
  return ApiAuthNotifier();
});

final widgetAuthProvider = ChangeNotifierProvider<WidgetAuthNotifier>((ref) {
  return WidgetAuthNotifier()..init();
});
