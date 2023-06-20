import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/notifier/global_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/sidebar.dart';

class Layout extends ConsumerWidget {
  const Layout({super.key, required this.body});
  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final router =
            ModalRoute.of(context)?.settings.name ?? "/main/dashboard";
        debugPrint(router);
        ref.read(menuAuthProvider).changeRouterNoNavigation(router);
      },
    );

    return Material(
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Sidebar(), Expanded(child: body)],
        ),
      ),
    );
  }
}
