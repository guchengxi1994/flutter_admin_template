// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/layout/components/sidebar_item.dart';
import 'package:flutter_admin_template_frontend/layout/models/sidemenu_item_model.dart';
import 'package:flutter_admin_template_frontend/layout/notifier/sidebar_notifier.dart';
import 'package:flutter_admin_template_frontend/notifier/global_notifier.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hovering/hovering.dart';

class Sidebar extends ConsumerWidget {
  Sidebar({super.key, this.header});
  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildContent(ref);
  }

  late SidemenuModel dashboardModel = SidemenuModel(
      router: "dashboard",
      title: "Dashboard",
      index: 0,
      icon: const Icon(Icons.dashboard),
      iconOnHover: const Icon(
        Icons.dashboard_outlined,
        color: Colors.white,
      ));

  late SidemenuModel userdModel = SidemenuModel(
      router: "user",
      title: "User",
      index: 1,
      icon: const Icon(Icons.people),
      iconOnHover: const Icon(
        Icons.people_outline,
        color: Colors.white,
      ));

  late SidemenuModel deptModel = SidemenuModel(
      router: "dept",
      title: "Department",
      index: 2,
      icon: const Icon(Icons.local_fire_department),
      iconOnHover: const Icon(
        Icons.local_fire_department_outlined,
        color: Colors.white,
      ));

  late SidemenuModel menuModel = SidemenuModel(
      router: "menu",
      title: "Menu",
      index: 3,
      icon: const Icon(Icons.menu),
      iconOnHover: const Icon(
        Icons.menu_outlined,
        color: Colors.white,
      ));

  Widget _buildContent(WidgetRef ref) {
    return Container(
      width: !ref.watch(sidebarProvider).isCollapse
          ? AppStyle.sidebarWidth
          : AppStyle.sidebarCollapseWidth,
      color: AppStyle.appBlue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          header ??
              SizedBox(
                height: AppStyle.sidebarHeaderHeight,
              ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                SidebarItem(
                  model: dashboardModel,
                  visible:
                      ref.watch(menuAuthProvider).inSet(dashboardModel.router),
                ),
                SidebarItem(
                  model: userdModel,
                  visible: ref.watch(menuAuthProvider).inSet(userdModel.router),
                ),
                SidebarItem(
                  model: deptModel,
                  visible: ref.watch(menuAuthProvider).inSet(deptModel.router),
                ),
                SidebarItem(
                  model: menuModel,
                  visible: ref.watch(menuAuthProvider).inSet(menuModel.router),
                ),
              ],
            ),
          )),
          GestureDetector(
            onTap: () {
              final i = ref.read(sidebarProvider).isCollapse;
              ref.read(sidebarProvider).changeIsCollapse(!i);
            },
            child: _buildCollapseButton(ref),
          )
        ],
      ),
    );
  }

  Widget _buildCollapseButton(WidgetRef ref) {
    if (ref.watch(sidebarProvider).isCollapse) {
      return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            width: AppStyle.sidebarCollapseWidth - 10,
            height: AppStyle.sidebarCollapseWidth - 10,
            child: Tooltip(
              message: "Open",
              child: HoverWidget(
                hoverChild: Container(
                  decoration: BoxDecoration(
                      color: AppStyle.hoveringBackgroundColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  child: const Icon(Icons.chevron_right, color: Colors.white),
                ),
                onHover: (v) {},
                child: const Icon(Icons.chevron_right),
              ),
            ),
          ));
    } else {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          height: AppStyle.sidebarCollapseWidth - 10,
          width: AppStyle.sidebarWidth - 20,
          child: HoverWidget(
              hoverChild: Container(
                decoration: BoxDecoration(
                    color: AppStyle.hoveringBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                padding: const EdgeInsets.only(left: 10),
                child: const Row(
                  children: [
                    Icon(Icons.chevron_left, color: Colors.white),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Collapse",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              onHover: (v) {},
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: const Row(
                  children: [
                    Icon(Icons.chevron_left),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Collapse")
                  ],
                ),
              )),
        ),
      );
    }
  }
}
