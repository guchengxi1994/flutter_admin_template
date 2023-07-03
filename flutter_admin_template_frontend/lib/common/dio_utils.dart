import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/apis.dart';
import 'package:flutter_admin_template_frontend/common/local_storage.dart';
import 'package:flutter_admin_template_frontend/routers.dart';

import 'smart_dialog_utils.dart';

class AuthInterCeptor extends Interceptor {
  final FatLocalStorage storage = FatLocalStorage();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if ("/system/user/login" != options.path) {
      options.queryParameters["token"] = await storage.getToken();

      List<String> apis = await storage.getApiAuth();
      var path = options.path.split("?").firstOrNull;
      if (!apis.contains(path) && !reservedApis.contains(path)) {
        SmartDialogUtils.error("无权访问");
        debugPrint("[no-auth] :${options.path}");
        return;
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data != null) {
      if (response.data['code'] == 40001 || response.data['code'] == 40002) {
        SmartDialogUtils.error("登录已过期");
        FatRouters.navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(FatRouters.loginScreen, (route) => false);
        return;
      }
    }
    super.onResponse(response, handler);
  }
}

class DioUtils {
  // ignore: prefer_final_fields
  static DioUtils _instance = DioUtils._internal();
  factory DioUtils() => _instance;
  Dio? _dio;

  DioUtils._internal() {
    _dio ??= Dio();
    _dio!.options.baseUrl = baseUrl;
    _dio!.interceptors.add(AuthInterCeptor());
  }

  ///get请求方法
  get(url, {params, options, cancelToken}) async {
    try {
      Response response = await _dio!.get(url,
          queryParameters: params, options: options, cancelToken: cancelToken);
      return response;
    } on Exception catch (e) {
      debugPrint('getHttp exception: $e');
      return null;
    }
  }

  ///put请求方法
  put(url, {data, params, options, cancelToken}) async {
    try {
      Response response = await _dio!.put(url,
          data: data,
          queryParameters: params,
          options: options,
          cancelToken: cancelToken);
      return response;
    } on Exception catch (e) {
      debugPrint('putHttp exception: $e');
      return null;
    }
  }

  ///post请求
  post(url, {data, params, options, cancelToken}) async {
    try {
      Response response = await _dio!.post(url,
          data: data,
          queryParameters: params,
          options: options,
          cancelToken: cancelToken);
      return response;
    } on Exception catch (e) {
      debugPrint('postHttp exception: $e');
      return null;
    }
  }

  //取消请求
  cancleRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
