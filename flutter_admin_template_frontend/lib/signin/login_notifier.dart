import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/apis.dart';
import 'package:flutter_admin_template_frontend/common/local_storage.dart';
import 'package:flutter_admin_template_frontend/common/smart_dialog_utils.dart';

import '../common/dio_utils.dart';
import 'models/models.dart';

class LoginNotifier extends ChangeNotifier {
  bool passwordVisible = true;
  bool isLoading = false;
  final DioUtils dioUtils = DioUtils();
  bool isPasswordEmpty = false;
  bool isUsernameEmpty = false;
  final FatLocalStorage storage = FatLocalStorage();

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

  Future<bool> login(String username, String password) async {
    isLoading = true;
    notifyListeners();

    LoginRequest request = LoginRequest(userName: username, password: password);
    Response? response =
        await dioUtils.post(apiDetails["login"], data: request.toJson());

    if (response == null) {
      SmartDialogUtils.error("未知错误");
      isLoading = false;
      notifyListeners();
      return false;
    } else {
      LoginResponse re = LoginResponse.fromJson(response.data);
      if (re.code != httpCodeOK) {
        SmartDialogUtils.error(re.message ?? "登录失败");
        isLoading = false;
        notifyListeners();
        return false;
      } else {
        await storage.setToken(re.data!);
        SmartDialogUtils.message("登录成功");
        isLoading = false;
        notifyListeners();
        return true;
      }
    }
  }
}
