import 'package:flutter/material.dart';

class MenuAuthController extends ChangeNotifier {
  final Set<String> _auth = {};

  init() async {
    // for test
    _auth.add("Dashboard");
    _auth.add("Dashboard/Menu");
    _auth.add("Users");
    _auth.add("Department");
    _auth.add("Roles");
    _auth.add("Notifications");
    _auth.add("Settings");
  }

  bool inSet(String i) {
    return _auth.contains(i);
  }
}
