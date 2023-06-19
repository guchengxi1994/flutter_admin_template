import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  bool passwordVisible = true;
  bool isLoading = false;

  bool isPasswordEmpty = false;
  bool isUsernameEmpty = false;

  changeUsernameEmptyStatus(bool b) {
    if (isUsernameEmpty != b) {
      isUsernameEmpty = b;
      notifyListeners();
    }
  }

  changePasswordEmptyStatus(bool b) {
    if (isPasswordEmpty != b) {
      isPasswordEmpty = b;
      notifyListeners();
    }
  }

  changePasswordStatus() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  changeLoadingStatus(bool b) {
    isLoading = b;
    notifyListeners();
  }
}
