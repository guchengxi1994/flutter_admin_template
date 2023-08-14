import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/apis.dart';
import 'package:flutter_admin_template_frontend/common/dio_utils.dart';
import 'package:flutter_admin_template_frontend/common/smart_dialog_utils.dart';
import 'package:flutter_admin_template_frontend/dept/models/single_dept_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/dept_tree_response.dart';

class DeptNotifier extends ChangeNotifier {
  // ignore: avoid_init_to_null
  late DepartmentTree? tree = null;
  final DioUtils dioUtils = DioUtils();

  init() async {
    final Response? response = await dioUtils.get(apiDetails['getDeptTree']);
    if (response != null) {
      if (response.data['code'] != 20000) {
        SmartDialogUtils.error(response.data['message']);
        return;
      }
      tree = DepartmentTree.fromJson(response.data['data']);
    } else {
      SmartDialogUtils.error("系统异常");
      return;
    }
  }

  Future<DepartmentTree?> getWithout(int id) async {
    final Response? response =
        await dioUtils.get("${apiDetails['getDeptTreeWithout']!}?id=$id");
    if (response != null) {
      if (response.data['code'] != 20000) {
        SmartDialogUtils.error(response.data['message']);
        return null;
      }
      return DepartmentTree.fromJson(response.data['data']);
    } else {
      SmartDialogUtils.error("系统异常");
      return null;
    }
  }

  Future<SingleDepartmentResponse?> querySingleById(int deptId) async {
    final Response? response =
        await dioUtils.get("${apiDetails['getDeptDetail']!}?id=$deptId");
    if (response != null) {
      if (response.data['code'] != 20000) {
        SmartDialogUtils.error(response.data['message']);
        return null;
      }
      return SingleDepartmentResponse.fromJson(response.data['data']);
    } else {
      SmartDialogUtils.error("系统异常");
      return null;
    }
  }
}

final deptProvider = ChangeNotifierProvider((ref) => DeptNotifier());
