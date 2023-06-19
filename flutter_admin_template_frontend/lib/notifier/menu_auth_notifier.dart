import 'package:flutter/material.dart';

class MenuAuthNotifier extends ChangeNotifier {
  final Set<String> _auth = {};
  final PageController controller = PageController();

  int currentPageIndex = 0;
  changeIndex(int id) {
    if (currentPageIndex != id) {
      currentPageIndex = id;
      controller.jumpToPage(id);
      notifyListeners();
    }
  }

  init() async {
    // for test
    _auth.add("dashboard");
    _auth.add("user");
    _auth.add("dept");
    _auth.add("menu");
  }

  bool inSet(String i) {
    return _auth.contains(i);
  }
}
