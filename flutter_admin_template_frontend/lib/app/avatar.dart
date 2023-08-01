import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/routers.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("aaa");
        Navigator.of(context)
            .pushNamedAndRemoveUntil(FatRouters.loginScreen, (route) => false);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          width: AppStyle.avatarSize,
          height: AppStyle.avatarSize,
          child: Image.asset(
            "assets/images/avatar.png",
          ),
        ),
      ),
    );
  }
}
