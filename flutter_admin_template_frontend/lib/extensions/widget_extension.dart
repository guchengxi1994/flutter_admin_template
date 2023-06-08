import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/widget_auth_controller.dart';

extension WidgetExtension on Widget {
  Widget wrapper(String id, BuildContext context) {
    bool visible = context.read<WidgetAuthController>().inSet(id);
    return Visibility(visible: visible, child: this);
  }
}
