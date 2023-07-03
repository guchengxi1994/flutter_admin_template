// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/layout/components/sidebar_item.dart';
import 'package:flutter_admin_template_frontend/layout/models/sidebar_item_model.dart';
import 'package:flutter_admin_template_frontend/layout/notifier/sidebar_notifier.dart';
import 'package:flutter_admin_template_frontend/notifier/global_notifier.dart';
import 'package:flutter_admin_template_frontend/routers.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hovering/hovering.dart';

import 'sidebar_item_with_children.dart';

class Sidebar extends ConsumerStatefulWidget {
  const Sidebar({super.key, this.header});
  final Widget? header;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return SidebarState();
  }
}

class SidebarState extends ConsumerState<Sidebar> {
  late SidebarModel dashboardModel = SidebarModel(
      router: "/main/dashboard",
      title: "Dashboard",
      index: 0,
      icon: SidebarIcons.dashBoard,
      iconOnHover: SidebarIcons.dashBoardOnHover);

  late SidebarModel userdModel = SidebarModel(
      router: "/main/user",
      title: "User",
      index: 1,
      icon: SidebarIcons.user,
      iconOnHover: SidebarIcons.userOnHover);

  late SidebarModel deptModel = SidebarModel(
      router: "/main/dept",
      title: "Department",
      index: 2,
      icon: SidebarIcons.dept,
      iconOnHover: SidebarIcons.deptOnHover);

  late SidebarModel menuModel = SidebarModel(
      router: "/main/menu",
      title: "Menu",
      index: 3,
      icon: SidebarIcons.menu,
      iconOnHover: SidebarIcons.menuOnHover);

  late SidebarModel roleModel = SidebarModel(
      router: "/main/role",
      title: "Role",
      index: 4,
      icon: SidebarIcons.role,
      iconOnHover: SidebarIcons.roleOnHover);

  late SidebarModel logModel = SidebarModel(
      router: "/main/logs",
      title: "Log",
      index: 5,
      icon: SidebarIcons.log,
      iconOnHover: SidebarIcons.logOnHover,
      children: [
        SidebarModel(
            router: "/main/logs/operation",
            title: "Operation",
            index: 5,
            icon: SidebarIcons.operation,
            iconOnHover: SidebarIcons.operationOnHover),
        SidebarModel(
            router: "/main/logs/signin",
            title: "Sign in",
            index: 5,
            icon: SidebarIcons.signin,
            iconOnHover: SidebarIcons.signinOnHover),
      ]);

  // ignore: prefer_typing_uninitialized_variables
  var future;

  List<String> auths = [];

  loadAuth() async {
    auths = await ref.read(menuAuthProvider).loadCache();
  }

  @override
  void initState() {
    super.initState();
    future = loadAuth();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildContent();
        }
        return SizedBox(
          width: AppStyle.sidebarWidth,
        );
      },
    );
  }

  Widget _buildContent() {
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
          widget.header ??
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      FatRouters.loginScreen, (v) => false);
                },
                child: /* TODO replace with `Header` */ MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: SizedBox(
                    width: isCollapse
                        ? AppStyle.sidebarCollapseWidth
                        : AppStyle.sidebarWidth,
                    height: AppStyle.sidebarHeaderHeight,
                  ),
                ),
              ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                SidebarItem(
                  model: dashboardModel,
                  visible: auths.contains(dashboardModel.router),
                ),
                SidebarItem(
                  model: userdModel,
                  visible: auths.contains(userdModel.router),
                ),
                SidebarItem(
                  model: deptModel,
                  visible: auths.contains(deptModel.router),
                ),
                SidebarItem(
                  model: menuModel,
                  visible: auths.contains(menuModel.router),
                ),
                SidebarItem(
                  model: roleModel,
                  visible: auths.contains(roleModel.router),
                ),
                SidebarItemWithChildren(
                  model: logModel,
                  visible: auths.contains(logModel.router),
                  subVisible: ref.watch(menuAuthProvider).subVisibles[0],
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
            child: _buildCollapseButton(),
          )
        ],
      ),
    );
  }

  Widget _buildCollapseButton() {
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
