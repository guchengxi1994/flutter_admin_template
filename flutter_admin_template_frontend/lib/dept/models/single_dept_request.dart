import 'package:dev_utils/dev_utils.dart';

class SingleDeptRequest extends BaseRequest with HttpMixin {
  final int deptId;
  SingleDeptRequest({required this.deptId});

  @override
  Future<BaseResponse?> queryById(String url,
      {params,
      options,
      cancelToken,
      Function? onError,
      ShowErrorMessage? showErrorMessage}) {
    return super
        .queryById(url, onError: onError, showErrorMessage: showErrorMessage);
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
    return {"id": deptId};
  }

  @override
  Future<bool> updateById(String url,
      {params, options, cancelToken, Function? onError}) {
    throw UnimplementedError();
  }
}
