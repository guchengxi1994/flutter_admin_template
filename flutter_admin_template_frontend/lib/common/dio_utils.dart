import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/common/local_storage.dart';
import 'package:flutter_admin_template_frontend/routers.dart';

class AuthInterCeptor extends Interceptor {
  final FatLocalStorage storage = FatLocalStorage();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path != "/system/user/login") {
      options.queryParameters["token"] = await storage.getToken();
    }

    super.onRequest(options, handler);
  }
}

class DioUtils {
  // ignore: prefer_final_fields
  static DioUtils _instance = DioUtils._internal();
  factory DioUtils() => _instance;
  Dio? _dio;

  DioUtils._internal() {
    _dio ??= Dio();
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

      /// FIXME
      ///
      /// actix-web cors error
      ///
      /// not sure why
      FatRouters.navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(FatRouters.loginScreen, (route) => false);
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
