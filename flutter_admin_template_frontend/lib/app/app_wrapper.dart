import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/notifier/app_color_notifier.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'custom_appbar.dart';

class AppWrapper extends ConsumerStatefulWidget {
  const AppWrapper({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends ConsumerState<AppWrapper> with WindowListener {
  @override
  Widget build(BuildContext context) {
    var routePath = ModalRoute.of(context)!.settings.name;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(0),
            // 边框
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Scaffold(
              backgroundColor: ref.watch(colorNotifier).current,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(AppStyle.appbarHeight),
                child: WindowCaption(
                  title:
                      routePath == "/loginScreen" ? null : const CustomAppbar(),
                  brightness: Brightness.dark,
                  backgroundColor: Colors.transparent,
                ),
              ),
              body: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
