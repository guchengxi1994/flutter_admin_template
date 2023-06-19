import 'package:flutter/material.dart';

class WidgetAuthNotifier extends ChangeNotifier {
  /// module/component/id
  ///
  /// `:` if empty
  final Set<String> _auth = {};

  init() async {
    // for test
    _auth.add("main/:/1");
    _auth.add("main/:/2");
    _auth.add("main/:/3");
  }

  bool inSet(String i) {
    return _auth.contains(i);
  }
}
