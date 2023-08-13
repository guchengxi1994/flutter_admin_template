import 'package:fat_widgets/fat_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/common/future_builder.dart';
import 'package:flutter_admin_template_frontend/notifier/app_color_notifier.dart';
import 'package:flutter_admin_template_frontend/notifier/global_notifier.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_admin_template_frontend/dept/dept_screen.dart'
    deferred as dept;
import 'package:flutter_admin_template_frontend/menu/menu_screen.dart'
    deferred as menu;
import 'package:flutter_admin_template_frontend/role/role_screen.dart'
    deferred as role;
import 'package:flutter_admin_template_frontend/user/user_screen.dart'
    deferred as user;

class SysManagementScreen extends ConsumerStatefulWidget {
  const SysManagementScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return SysManagementScreenState();
  }
}

class SysManagementScreenState extends ConsumerState<SysManagementScreen>
    with AutomaticKeepAliveClientMixin {
  final controller = PageController();

  @override
  void initState() {
    super.initState();
    future = loadAuth();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // ignore: prefer_typing_uninitialized_variables
  var future;

  List<String> auths = [];

  loadAuth() async {
    auths = await ref.read(menuAuthProvider).loadCache();
    if (auths.contains("/main/user")) {
      pages.add(userPage);
    }

    if (auths.contains("/main/dept")) {
      pages.add(deptPage);
    }

    if (auths.contains("/main/role")) {
      pages.add(rolePage);
    }

    if (auths.contains("/main/menu")) {
      pages.add(menuPage);
    }
  }

  late Widget userPage = FutureLoaderWidget(
      builder: (context) => user.UserScreen(),
      loadWidgetFuture: user.loadLibrary());

  late Widget deptPage = FutureLoaderWidget(
      builder: (context) => dept.DeptScreen(),
      loadWidgetFuture: dept.loadLibrary());

  late Widget rolePage = FutureLoaderWidget(
      builder: (context) => role.RoleScreen(),
      loadWidgetFuture: role.loadLibrary());

  late Widget menuPage = FutureLoaderWidget(
      builder: (context) => menu.MenuScreen(),
      loadWidgetFuture: menu.loadLibrary());

  late List<Widget> pages = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      builder: (c, s) {
        if (s.connectionState == ConnectionState.done) {
          return Row(
            children: [
              AnimatedSingleLevelSidemenu(
                header: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxHeight: 1, minHeight: 1)),
                decoration: BoxDecoration(
                    color: ref.watch(colorNotifier).currentColorTheme.$3,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                indicatorSize: AppStyle.subMenuIndicatorSize,
                height: MediaQuery.of(context).size.height,
                items: [
                  if (auths.contains("/main/user"))
                    BaseSidemenuData(
                        leading: SidebarIcons.user,
                        padding: const EdgeInsets.only(bottom: 12, left: 10),
                        height: 60,
                        width: 280,
                        index: 0,
                        onItemClicked: (p0) {
                          controller.jumpToPage(p0);
                        },
                        title: const Text("User Management")),
                  if (auths.contains("/main/dept"))
                    BaseSidemenuData(
                        leading: SidebarIcons.dept,
                        padding: const EdgeInsets.only(bottom: 12, left: 10),
                        height: 60,
                        width: 280,
                        index: 1,
                        onItemClicked: (p0) {
                          controller.jumpToPage(p0);
                        },
                        title: const Text("Dept Management")),
                  if (auths.contains("/main/role"))
                    BaseSidemenuData(
                        leading: SidebarIcons.role,
                        padding: const EdgeInsets.only(bottom: 12, left: 10),
                        height: 60,
                        width: 280,
                        index: 2,
                        onItemClicked: (p0) {
                          controller.jumpToPage(p0);
                        },
                        title: const Text("Role Management")),
                  if (auths.contains("/main/menu"))
                    BaseSidemenuData(
                        leading: SidebarIcons.menu,
                        padding: const EdgeInsets.only(bottom: 12, left: 10),
                        height: 60,
                        width: 280,
                        index: 3,
                        onItemClicked: (p0) {
                          controller.jumpToPage(p0);
                        },
                        title: const Text("Menu Management")),
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
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: future,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
