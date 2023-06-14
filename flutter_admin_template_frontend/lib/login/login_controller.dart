import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  bool passwordVisible = true;
  bool isLoading = false;

  changePasswordStatus() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  changeLoadingStatus(bool b) {
    isLoading = b;
    notifyListeners();
  }
}
