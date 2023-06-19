import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/dashboard/dashboard_screen.dart';
import 'package:flutter_admin_template_frontend/dept/dept_screen.dart';
import 'package:flutter_admin_template_frontend/menu/menu_screen.dart';
import 'package:flutter_admin_template_frontend/user/user_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/global_notifier.dart';
import 'components/sidebar.dart';

class Layout extends ConsumerWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return Material(
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Sidebar(), Expanded(child: _body(size, context, ref))],
        ),
      ),
    );
  }

  Widget _body(Size size, BuildContext context, WidgetRef ref) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blueGrey[50],
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: ref.read(menuAuthProvider).controller,
        children: const [
          DashboardScreen(),
          UserScreen(),
          DeptScreen(),
          MenuScreen()
        ],
      ),
    );
  }
}
