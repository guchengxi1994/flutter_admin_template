import 'package:dev_utils/dev_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/apis.dart';
import 'package:flutter_admin_template_frontend/common/smart_dialog_utils.dart';
import 'package:flutter_admin_template_frontend/dept/models/single_dept_request.dart';
import 'package:flutter_admin_template_frontend/dept/models/single_dept_response.dart';
import 'package:flutter_admin_template_frontend/dept/models/tree_without_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/dept_tree_request.dart';
import 'models/dept_tree_response.dart';

class DeptNotifier extends ChangeNotifier {
  // ignore: avoid_init_to_null
  late DepartmentTree? tree = null;
  // final DioUtils dioUtils = DioUtils();

  init() async {
    final BaseResponse? response = await DeptTreeRequest().query(
      apiDetails['getDeptTree']!,
      onError: () {
        SmartDialogUtils.error("访问异常");
        return;
      },
      showErrorMessage: (p0) {
        SmartDialogUtils.error(p0);
        return;
      },
    );
    if (response != null) {
      tree = DepartmentTree.fromJson(response.data as Map<String, dynamic>);
    }
  }

  Future<DepartmentTree?> getWithout(int id) async {
    TreeWithoutRequest request = TreeWithoutRequest(id: id);

    final BaseResponse? response = await request.queryById(
      apiDetails['getDeptTreeWithout']!,
      onError: () {
        SmartDialogUtils.error("访问异常");
      },
      showErrorMessage: (p0) {
        SmartDialogUtils.error(p0);
      },
    );
    if (response != null) {
      return DepartmentTree.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<SingleDepartmentResponse?> querySingleById(int deptId) async {
    final SingleDeptRequest singleDeptRequest =
        SingleDeptRequest(deptId: deptId);

    final BaseResponse? response = await singleDeptRequest.queryById(
      apiDetails['getDeptDetail']!,
      onError: () {
        SmartDialogUtils.error("访问异常");
      },
      showErrorMessage: (p0) {
        SmartDialogUtils.error(p0);
      },
    );
    if (response != null) {
      return SingleDepartmentResponse.fromJson(
          response.data as Map<String, dynamic>);
    }
    return null;
  }
}

final deptProvider = ChangeNotifierProvider((ref) => DeptNotifier());
