import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/common/local_storage.dart';
import 'package:flutter_admin_template_frontend/styles/theme/color_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppColorNotifier extends ChangeNotifier {
  final FatLocalStorage storage = FatLocalStorage();
  final ColorTheme _colorTheme = ColorTheme();

  init() async {
    final s = await storage.getThemeColor();
    try {
      _baseTheme = ColorTheme.choices[s];
      notifyListeners();
    } catch (_) {}
  }

  changeCurrent(Color color) {
    int index = _colorTheme.baseColors.indexOf(color);

    if (index != -1) {
      if (_baseTheme.$0 != color) {
        _baseTheme = ColorTheme.choices[index];
        notifyListeners();
      }

      storage.setThemeColor(index);
    }
  }

  late BaseTheme _baseTheme = ColorTheme.choices[0];

  Color get current => _baseTheme.$0;
  BaseTheme get currentColorTheme => _baseTheme;
}

final colorNotifier =
    ChangeNotifierProvider((ref) => AppColorNotifier()..init());
