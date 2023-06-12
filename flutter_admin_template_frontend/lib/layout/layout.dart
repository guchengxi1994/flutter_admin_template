import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

import '../controllers/global_controller.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  List<CollapsibleItem> _items = [];
  String _headline = "";
  @override
  void initState() {
    super.initState();
    _items = [
      CollapsibleItem(
          visible: context.read<MenuAuthController>().inSet("Dashboard"),
          router: "Dashboard",
          text: 'Dashboard',
          icon: Icons.assessment,
          onPressed: () => setState(() => _headline = 'DashBoard'),
          onHold: () => ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Dashboard"))),
          isSelected: true,
          subItems: [
            CollapsibleItem(
              visible:
                  context.read<MenuAuthController>().inSet("Dashboard/Menu"),
              text: 'Menu',
              router: "Dashboard/Menu",
              icon: Icons.menu,
              onPressed: () => setState(() => _headline = 'Menu'),
              onHold: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Menu"))),
            )
          ]),
      CollapsibleItem(
        visible: context.read<MenuAuthController>().inSet("Users"),
        text: 'Users',
        router: "Users",
        icon: Icons.search,
        onPressed: () => setState(() => _headline = 'Search'),
        onHold: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Search"))),
      ),
      CollapsibleItem(
        visible: context.read<MenuAuthController>().inSet("Department"),
        text: 'Department',
        router: 'Department',
        icon: Icons.local_fire_department,
        onPressed: () => setState(() => _headline = 'Department'),
        onHold: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Department"))),
      ),
      CollapsibleItem(
        visible: context.read<MenuAuthController>().inSet("Roles"),
        router: "Roles",
        text: 'Roles',
        icon: Icons.people,
        onPressed: () => setState(() => _headline = 'Roles'),
        onHold: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Roles"))),
      ),
      CollapsibleItem(
        visible: context.read<MenuAuthController>().inSet("Notifications"),
        router: "Notifications",
        text: 'Notifications',
        icon: Icons.notifications,
        onPressed: () => setState(() => _headline = 'Notifications'),
        onHold: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Notifications"))),
      ),
      CollapsibleItem(
        visible: context.read<MenuAuthController>().inSet("Settings"),
        router: "Settings",
        text: 'Settings',
        icon: Icons.settings,
        onPressed: () => setState(() => _headline = 'Settings'),
        onHold: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Settings"))),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: CollapsibleSidebar(
        isCollapsed: MediaQuery.of(context).size.width <= 800,
        items: _items,
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
        body: _body(size, context),
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
    );
  }

  Widget _body(Size size, BuildContext context) {
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
              _headline,
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
