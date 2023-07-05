import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/apis.dart' show websocketUrl;
import 'package:flutter_admin_template_frontend/common/local_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketNotifier extends ChangeNotifier {
  late final WebSocketChannel channel;
  final FatLocalStorage storage = FatLocalStorage();

  init() async {
    final token = await storage.getToken();
    if (token == "") {
      return;
    }
    final wsUrl = Uri.parse("$websocketUrl/$token");
    channel = WebSocketChannel.connect(wsUrl);

    channel.stream.listen((event) {
      debugPrint("[flutter] ws recieved: ${event.toString()}");
    });
  }
}
