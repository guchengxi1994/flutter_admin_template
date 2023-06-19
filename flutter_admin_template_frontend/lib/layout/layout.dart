import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/sidebar.dart';

class Layout extends ConsumerWidget {
  const Layout({super.key, required this.body});
  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
