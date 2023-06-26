import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../common/dio_utils.dart';
import '../common/smart_dialog_utils.dart';
import 'base_response.dart';
import 'base_request.dart';

class BaseTableNotifier<Q extends BaseRequest, R extends BaseResponse>
    extends ChangeNotifier {
  final DioUtils dioUtils = DioUtils();

  List records = [];

  int totalCount = 0;

  int pageLength = 0;
  int currentIndex = 1;

  int getPageCount() {
    int s;
    if (totalCount % 10 == 0) {
      s = totalCount ~/ 10;
    } else {
      s = totalCount ~/ 10 + 1;
    }
    return s;
  }

  init(String url, String method, {Q? request}) async {
    assert((method == "post" && request != null) || method == "get");
    currentIndex = 1;

    Response? r;
    if (method == "post") {
      r = await dioUtils.post(url, data: request!.toJson());
    } else {
      r = await dioUtils.get(url);
    }

    if (r != null) {
      if (r.data['code'] != 20000) {
        SmartDialogUtils.error(r.data['message'].toString());
      } else {
        BaseResponse response = BaseResponse.fromJson(r.data['data']);
        records = response.records ?? [];
        totalCount = response.count ?? 0;
        pageLength = getPageCount();
        notifyListeners();
      }
    }
  }

  onPageIndexChange(int index, String url,
      {Map<String, dynamic> parameters = const {}}) async {
    Response? r = await dioUtils.get(url);
    if (r != null) {
      if (r.data['code'] != 20000) {
        SmartDialogUtils.error(r.data['message'].toString());
      } else {
        BaseResponse response = BaseResponse.fromJson(r.data['data']);
        records = response.records ?? [];
        totalCount = response.count ?? 0;
        pageLength = getPageCount();
        notifyListeners();
      }
    }
  }

  onReset(String url, String method, {Q? request}) async {
    assert((method == "post" && request != null) || method == "get");
    currentIndex = 1;

    Response? r;
    if (method == "post") {
      r = await dioUtils.post(url, data: request!.toJson());
    } else {
      r = await dioUtils.get(url);
    }

    if (r != null) {
      if (r.data['code'] != 20000) {
        SmartDialogUtils.error(r.data['message'].toString());
      } else {
        BaseResponse response = BaseResponse.fromJson(r.data['data']);
        records = response.records ?? [];
        totalCount = response.count ?? 0;
        pageLength = getPageCount();
        notifyListeners();
      }
    }
  }

  onSubmit(String url, DateTime? first, DateTime? last, String? status,
      String? keyword, bool b) async {
    Response? r = await dioUtils.get(url);
    if (r != null) {
      if (r.data['code'] != 20000) {
        SmartDialogUtils.error(r.data['message'].toString());
      } else {
        BaseResponse response = BaseResponse.fromJson(r.data['data']);
        records = response.records ?? [];
        totalCount = response.count ?? 0;
        pageLength = getPageCount();
        notifyListeners();
      }
    }
  }
}
