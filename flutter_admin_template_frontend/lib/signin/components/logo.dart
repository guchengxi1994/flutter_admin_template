import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/notifier/app_color_notifier.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoWidget extends ConsumerWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: AppStyle.loginLogoHeight,
      child: Text(
        width >= 900 ? "Flutter Admin Template" : "FAT",
        style: TextStyle(
          fontSize: AppStyle.loginLogoFontSize,
          color: ref.watch(colorNotifier).currentColorTheme.$1,
        ),
      ),
    );
  }
}
