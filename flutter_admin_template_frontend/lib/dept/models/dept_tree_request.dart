import 'package:dev_utils/dev_utils.dart';

class DeptTreeRequest extends BaseRequest with HttpMixin {
  @override
  Future<BaseResponse?> query(String url,
      {params,
      options,
      cancelToken,
      Function? onError,
      ShowErrorMessage? showErrorMessage}) {
    return super
        .query(url, onError: onError, showErrorMessage: showErrorMessage);
  }

  @override
  Future<bool> create() {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteById(String url,
      {params, options, cancelToken, Function? onError}) {
    throw UnimplementedError();
  }

  @override
  Future<List<BaseResponse>?> queryMany(String url,
      {params, options, cancelToken, Function? onError}) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  Future<bool> updateById(String url,
      {params, options, cancelToken, Function? onError}) {
    throw UnimplementedError();
  }
}
