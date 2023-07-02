import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_admin_template_frontend/common/smart_dialog_utils.dart';
import 'package:flutter_admin_template_frontend/role/models/role_list_response.dart';
import 'package:flutter_admin_template_frontend/table/base_request.dart';
import 'package:flutter_admin_template_frontend/table/base_table_notifier.dart';

import '../apis.dart';
import '../table/base_response.dart';
import 'models/role_detail_response.dart';

class RoleNotifier<_ extends BaseRequest, RoleListResponse extends BaseResponse>
    extends BaseTableNotifier {
  @override
  init(String url, String method, {BaseRequest? request}) async {
    String url = apiDetails["getAllRoles"]!;
    return super.init(url, "get", request: null);
  }

  @override
  List<Records> get records => _convertListToRecord();

  List<Records> _convertListToRecord() {
    List<Records> result = [];
    for (final i in super.records) {
      final r = _convertStringToRecord(i);
      if (r != null) {
        result.add(r);
      } else {
        result.add(Records(
          roleId: 0,
          roleName: "ERROR",
          createTime: "ERROR",
          updateTime: "ERROR",
          remark: "ERROR",
        ));
      }
    }
    return result;
  }

  Records? _convertStringToRecord(dynamic s) {
    try {
      final Map<String, dynamic> m;
      if (s is String) {
        m = jsonDecode(s);
      } else if (s is Map) {
        m = s as Map<String, dynamic>;
      } else {
        m = {};
        throw Exception("[flutter] cannot read content");
      }

      return Records.fromJson(m);
    } catch (e) {
      return null;
    }
  }

  Future<RoleDeailsResponse?> getDetailById(int id) async {
    String url = "${apiDetails["getDetailsById"]!}?id=$id";
    Response? response = await dioUtils.get(url);
    if (response != null) {
      if (response.data['code'] != httpCodeOK) {
        SmartDialogUtils.error(response.data['message'].toString());
        return null;
      } else {
        RoleDeailsResponse roleDeailsResponse =
            RoleDeailsResponse.fromJson(response.data['data']);
        return roleDeailsResponse;
      }
    }

    return null;
  }
}
