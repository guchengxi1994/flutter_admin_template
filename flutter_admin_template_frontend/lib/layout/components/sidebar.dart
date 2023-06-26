// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/layout/components/sidebar_item.dart';
import 'package:flutter_admin_template_frontend/layout/models/sidebar_item_model.dart';
import 'package:flutter_admin_template_frontend/layout/notifier/sidebar_notifier.dart';
import 'package:flutter_admin_template_frontend/notifier/global_notifier.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hovering/hovering.dart';

import 'sidebar_item_with_children.dart';

class Sidebar extends ConsumerWidget {
  Sidebar({super.key, this.header});
  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildContent(ref);
  }

  late SidebarModel dashboardModel = SidebarModel(
      router: "/main/dashboard",
      title: "Dashboard",
      index: 0,
      icon: const Icon(Icons.dashboard),
      iconOnHover: const Icon(
        Icons.dashboard_outlined,
        color: Colors.white,
      ));

  late SidebarModel userdModel = SidebarModel(
      router: "/main/user",
      title: "User",
      index: 1,
      icon: const Icon(Icons.people),
      iconOnHover: const Icon(
        Icons.people_outline,
        color: Colors.white,
      ));

  late SidebarModel deptModel = SidebarModel(
      router: "/main/dept",
      title: "Department",
      index: 2,
      icon: const Icon(Icons.local_fire_department),
      iconOnHover: const Icon(
        Icons.local_fire_department_outlined,
        color: Colors.white,
      ));

  late SidebarModel menuModel = SidebarModel(
      router: "/main/menu",
      title: "Menu",
      index: 3,
      icon: const Icon(Icons.menu),
      iconOnHover: const Icon(
        Icons.menu_outlined,
        color: Colors.white,
      ));

  late SidebarModel logModel = SidebarModel(
      router: "/main/logs",
      title: "Log",
      index: 3,
      icon: const Icon(Icons.details),
      iconOnHover: const Icon(
        Icons.details_outlined,
        color: Colors.white,
      ),
      children: [
        SidebarModel(
            router: "/main/logs/operation",
            title: "Operation",
            index: 4,
            icon: const Icon(Icons.change_circle),
            iconOnHover: const Icon(
              Icons.change_circle_outlined,
              color: Colors.white,
            )),
        SidebarModel(
            router: "/main/logs/signin",
            title: "Sign in",
            index: 4,
            icon: const Icon(Icons.login),
            iconOnHover: const Icon(
              Icons.login_outlined,
              color: Colors.white,
            )),
      ]);

  Widget _buildContent(WidgetRef ref) {
    bool isCollapse = ref.watch(sidebarProvider).isCollapse;
    return Container(
      width:
          !isCollapse ? AppStyle.sidebarWidth : AppStyle.sidebarCollapseWidth,
      // color: AppStyle.appBlue,
      margin: !isCollapse ? null : const EdgeInsets.all(5),
      padding: isCollapse ? null : const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: AppStyle.appBlue,
          borderRadius: !isCollapse ? null : BorderRadius.circular(12)),
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
                // SidebarItem(
                //   model: logModel,
                //   visible: ref.watch(menuAuthProvider).inSet(logModel.router),
                // ),
                SidebarItemWithChildren(
                  model: logModel,
                  visible: ref.watch(menuAuthProvider).inSet(logModel.router),
                  subVisible: ref.read(menuAuthProvider).subVisibles[0],
                )
              ],
            ),
          )),
          GestureDetector(
            onTap: () async {
              final i = ref.read(sidebarProvider).isCollapse;
              if (i) {
                ref.read(menuAuthProvider).collapseAll();
              }

              await Future.delayed(const Duration(milliseconds: 100))
                  .then((value) {
                ref.read(sidebarProvider).changeIsCollapse(!i);
              });
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
