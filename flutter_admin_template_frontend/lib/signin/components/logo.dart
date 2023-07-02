import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: AppStyle.loginLogoHeight,
      child: Text(
        width >= 900 ? "Flutter Admin Template" : "FAT",
        style: TextStyle(
            fontSize: AppStyle.loginLogoFontSize,
            color: AppStyle.loginLogoColor),
      ),
    );
  }
}
