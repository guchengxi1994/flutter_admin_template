import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SidebarNotifier extends ChangeNotifier {
  bool isCollapse = false;

  changeIsCollapse(bool b) {
    if (isCollapse != b) {
      isCollapse = b;
      notifyListeners();
    }
  }
}

final sidebarProvider =
    ChangeNotifierProvider<SidebarNotifier>((ref) => SidebarNotifier());
