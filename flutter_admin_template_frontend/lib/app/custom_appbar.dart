// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';

import 'avatar.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final start = width / 2 - 150 - AppStyle.sidebarCollapseWidth;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const AvatarWidget(),
        SizedBox(
          width: start,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.grey[100]!.withOpacity(0.5)),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
          ),
          child: const SizedBox(
            width: 300,
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 20, color: Colors.white),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "搜索(Alt + F)",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
