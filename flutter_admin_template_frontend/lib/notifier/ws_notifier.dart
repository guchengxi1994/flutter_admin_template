import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/apis.dart' show websocketUrl;
import 'package:flutter_admin_template_frontend/common/local_storage.dart';
import 'package:flutter_admin_template_frontend/common/smart_dialog_utils.dart';
import 'package:flutter_admin_template_frontend/routers.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketNotifier extends ChangeNotifier {
  // ignore: avoid_init_to_null
  late WebSocketChannel? channel = null;
  final FatLocalStorage storage = FatLocalStorage();

  init() async {
    if (channel != null) {
      return;
    }

    final token = await storage.getToken();
    if (token == "") {
      return;
    }
    final wsUrl = Uri.parse("$websocketUrl/$token");
    channel = WebSocketChannel.connect(wsUrl);

    channel!.stream.listen((event) {
      debugPrint("[flutter] ws recieved: ${event.toString()}");
      if (event.toString() == "log out") {
        SmartDialogUtils.warning("角色已变更");
        FatRouters.navigatorKey.currentState!
            .pushNamedAndRemoveUntil(FatRouters.loginScreen, (route) => false);
      }
    });
  }
}
