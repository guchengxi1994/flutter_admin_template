import 'package:flutter/material.dart';

class RouterAuthController extends ChangeNotifier {
  final Set<String> _auth = {};

  init() async {
    // for test
    _auth.add("");
  }

  bool inSet(String i) {
    return _auth.contains(i);
  }
}
