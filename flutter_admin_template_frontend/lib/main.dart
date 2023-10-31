import 'package:dev_utils/api/dio_utils.dart';

import 'apis.dart';
import 'app/run_app_desktop.dart' if (dart.library.html) 'app/run_app.dart';
import 'common/dio_utils.dart' hide DioUtils;

void main() {
  final DioUtils dioUtils = DioUtils();
  dioUtils.addInterceptor(AuthInterCeptor());
  dioUtils.setBaseUrl(baseUrl);

  runAPP();
}
