import 'package:flutter/material.dart';

class ScrollerWidget extends StatelessWidget {
  ScrollerWidget({super.key, required this.child});
  final Widget child;

  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller2,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: controller2,
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          controller: controller,
          child: child,
        ),
      ),
    );
  }
}
