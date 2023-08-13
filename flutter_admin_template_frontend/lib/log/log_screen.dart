import 'package:fat_widgets/fat_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/notifier/app_color_notifier.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'log_summary_screen.dart';
import 'operation_log_screen.dart';
import 'sign_in_log_screen.dart';

class LogScreen extends ConsumerStatefulWidget {
  const LogScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return LogScreenState();
  }
}

class LogScreenState extends ConsumerState<LogScreen>
    with AutomaticKeepAliveClientMixin {
  late List<Widget> pages = [
    LogSummaryScreen(),
    const OperationLogScreen(),
    const SignInLogScreen()
  ];

  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      children: [
        AnimatedSingleLevelSidemenu(
          header: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 1, minHeight: 1)),
          decoration: BoxDecoration(
              color: ref.watch(colorNotifier).currentColorTheme.$3,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          indicatorSize: AppStyle.subMenuIndicatorSize,
          height: MediaQuery.of(context).size.height,
          items: [
            BaseSidemenuData(
                leading: const Icon(
                  Icons.abc,
                  size: 25,
                ),
                padding: const EdgeInsets.only(bottom: 12, left: 10),
                height: 60,
                width: 280,
                index: 0,
                onItemClicked: (p0) {
                  controller.jumpToPage(p0);
                },
                title: const Text("Summary")),
            BaseSidemenuData(
                leading: SidebarIcons.operation,
                padding: const EdgeInsets.only(bottom: 12, left: 10),
                height: 60,
                width: 280,
                index: 1,
                onItemClicked: (p0) {
                  controller.jumpToPage(p0);
                },
                title: const Text("Operation")),
            BaseSidemenuData(
                leading: SidebarIcons.signin,
                padding: const EdgeInsets.only(bottom: 12, left: 10),
                height: 60,
                width: 280,
                index: 2,
                onItemClicked: (p0) {
                  controller.jumpToPage(p0);
                },
                title: const Text("Sign in"))
          ],
          width: AppStyle.submenuWidth,
        ),
        Expanded(
            child: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: pages,
        ))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
