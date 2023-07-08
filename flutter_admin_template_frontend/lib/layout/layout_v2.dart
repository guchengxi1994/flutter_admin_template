import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fat_widgets/fat_widgets.dart';

import '../notifier/global_notifier.dart';

class LayoutV2 extends ConsumerStatefulWidget {
  const LayoutV2({super.key, required this.body});

  final Widget body;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return LayoutV2State();
  }
}

// ignore: must_be_immutable
class LayoutV2State extends ConsumerState<LayoutV2> {
  final GlobalKey<MultiLevelSideMenuState> globalKey = GlobalKey();

  // ignore: prefer_typing_uninitialized_variables
  var future;

  List<String> auths = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final router =
            ModalRoute.of(context)?.settings.name ?? "/main/dashboard";
        ref.read(menuAuthProvider).changeRouterNoNavigation(router);
        if (globalKey.currentState != null) {
          globalKey.currentState!
              .changeIndex(ref.read(menuAuthProvider).currentRouterId);
        }

        await ref.read(wsProvider).init();
      },
    );
    future = loadAuth();
  }

  loadAuth() async {
    auths = await ref.read(menuAuthProvider).loadCache();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      child: FutureBuilder(
          future: future,
          builder: (c, s) {
            if (s.connectionState == ConnectionState.done) {
              return _buildContent();
            }
            return const SizedBox();
          }),
    ));
  }

  Widget _buildContent() {
    return MultiLevelSideMenu(
      key: globalKey,
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            spreadRadius: 0.0,
            offset: Offset(5, 0), // shadow direction: bottom right
          )
        ],
      ),
      initialIndex: ref.watch(menuAuthProvider).currentRouterId,
      body: widget.body,
      destinations: [
        if (auths.contains("/main/dashboard"))
          const NavigationRailDestination(
            icon: SidebarIcons.dashBoard,
            selectedIcon: SidebarIcons.dashBoardOnHover,
            label: Text('Dashboard'),
          ),
        if (auths.contains("/main/user"))
          const NavigationRailDestination(
            icon: SidebarIcons.user,
            selectedIcon: SidebarIcons.userOnHover,
            label: Text('User'),
          ),
        if (auths.contains("/main/dept"))
          const NavigationRailDestination(
            icon: SidebarIcons.dept,
            selectedIcon: SidebarIcons.deptOnHover,
            label: Text('Department'),
          ),
        if (auths.contains("/main/menu"))
          const NavigationRailDestination(
            icon: SidebarIcons.menu,
            selectedIcon: SidebarIcons.menuOnHover,
            label: Text('Menu'),
          ),
        if (auths.contains("/main/role"))
          const NavigationRailDestination(
            icon: SidebarIcons.role,
            selectedIcon: SidebarIcons.roleOnHover,
            label: Text('Role'),
          ),
        if (auths.contains("/main/logs"))
          const NavigationRailDestination(
            icon: SidebarIcons.log,
            selectedIcon: SidebarIcons.logOnHover,
            label: Text('Log'),
          ),
      ],
      onDestinationSelected: (i) {
        ref.read(menuAuthProvider).changeRouterByRouterId(i);
      },
    );
  }
}
