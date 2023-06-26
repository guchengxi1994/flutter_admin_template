import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("zh_cn") +
      {"zh_cn": "输入用户名", "en_us": "Username"} +
      {"zh_cn": "登录记录", "en_us": "Sign In Logs"} +
      {"zh_cn": "没有记录", "en_us": "No Records"} +
      {"zh_cn": "记录编号", "en_us": "Sign In Id"} +
      {"zh_cn": "用户编号", "en_us": "User Id"} +
      {"zh_cn": "用户名", "en_us": "Username"} +
      {"zh_cn": "登录IP", "en_us": "Sign In IP"} +
      {"zh_cn": "登录状态", "en_us": "Sign In Status"} +
      {"zh_cn": "登录时间", "en_us": "Sign In Time"};

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
