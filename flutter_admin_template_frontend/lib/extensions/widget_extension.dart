import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/global_controller.dart';

extension WidgetExtension on Widget {
  Widget wrapper(String id, WidgetRef ref) {
    bool visible = ref.read(widgetAuthProvider).inSet(id);
    return Visibility(visible: visible, child: this);
  }
}
