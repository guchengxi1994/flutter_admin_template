import 'package:flutter/material.dart';

enum WindowType { mobile, desktop, tablet }

extension SizeExtension on Size {
  WindowType getType() {
    if (width < 850) {
      return WindowType.mobile;
    }

    if (width > 1100) {
      return WindowType.desktop;
    }

    return WindowType.tablet;
  }
}
