import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '../controllers/global_controller.dart';

class Layout extends ConsumerWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CollapsibleItem> items = [
      CollapsibleItem(
          visible: ref.read(menuAuthProvider).inSet("Dashboard"),
          router: "Dashboard",
          text: 'Dashboard',
          icon: Icons.assessment,
          onPressed: () =>
              ref.read(menuAuthProvider).changeHeadline("Dashboard"),
          onHold: () => ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Dashboard"))),
          isSelected: true,
          subItems: [
            CollapsibleItem(
              visible: ref.read(menuAuthProvider).inSet("Dashboard/Menu"),
              text: 'Menu',
              router: "Dashboard/Menu",
              icon: Icons.menu,
              onPressed: () =>
                  ref.read(menuAuthProvider).changeHeadline("Menu"),
              onHold: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Menu"))),
            )
          ]),
      CollapsibleItem(
        visible: ref.read(menuAuthProvider).inSet("Users"),
        text: 'Users',
        router: "Users",
        icon: Icons.search,
        onPressed: () => ref.read(menuAuthProvider).changeHeadline("Users"),
        onHold: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Users"))),
      ),
      CollapsibleItem(
        visible: ref.read(menuAuthProvider).inSet("Department"),
        text: 'Department',
        router: 'Department',
        icon: Icons.local_fire_department,
        onPressed: () =>
            ref.read(menuAuthProvider).changeHeadline("Department"),
        onHold: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Department"))),
      ),
      CollapsibleItem(
        visible: ref.read(menuAuthProvider).inSet("Roles"),
        router: "Roles",
        text: 'Roles',
        icon: Icons.people,
        onPressed: () => ref.read(menuAuthProvider).changeHeadline("Roles"),
        onHold: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Roles"))),
      ),
      CollapsibleItem(
        visible: ref.read(menuAuthProvider).inSet("Notifications"),
        router: "Notifications",
        text: 'Notifications',
        icon: Icons.notifications,
        onPressed: () =>
            ref.read(menuAuthProvider).changeHeadline("Notifications"),
        onHold: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Notifications"))),
      ),
      CollapsibleItem(
        visible: ref.read(menuAuthProvider).inSet("Settings"),
        router: "Settings",
        text: 'Settings',
        icon: Icons.settings,
        onPressed: () => ref.read(menuAuthProvider).changeHeadline("Settings"),
        onHold: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Settings"))),
      ),
    ];

    var size = MediaQuery.of(context).size;

    return Material(
      child: SafeArea(
        child: CollapsibleSidebar(
          isCollapsed: MediaQuery.of(context).size.width <= 800,
          items: items,
          collapseOnBodyTap: false,
          avatar: Builder(builder: (ctx) {
            return Container(
              width: 200,
              height: 100,
              child: Center(
                child: Text(
                  "This is title",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }),
          collapsedAvatar: Builder(builder: (ctx) {
            return Container(
              height: 100,
              child: Center(
                child: Text(
                  "Title",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }),
          onTitleTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Yay! Flutter Collapsible Sidebar!')));
          },
          body: _body(size, context, ref),
          backgroundColor: Colors.black,
          selectedTextColor: Colors.limeAccent,
          textStyle: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
          titleStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          toggleTitleStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          sidebarBoxShadow: const [
            BoxShadow(
              color: Colors.indigo,
              blurRadius: 20,
              spreadRadius: 0.01,
              offset: Offset(3, 3),
            ),
            BoxShadow(
              color: Colors.green,
              blurRadius: 50,
              spreadRadius: 0.01,
              offset: Offset(3, 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(Size size, BuildContext context, WidgetRef ref) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blueGrey[50],
      child: Center(
        child: Transform.rotate(
          angle: math.pi / 2,
          child: Transform.translate(
            offset: Offset(-size.height * 0.3, -size.width * 0.23),
            child: Text(
              ref.watch(menuAuthProvider).headLine,
              style: Theme.of(context).textTheme.headlineMedium,
              overflow: TextOverflow.visible,
              softWrap: false,
            ),
          ),
        ),
      ),
    );
  }
}
