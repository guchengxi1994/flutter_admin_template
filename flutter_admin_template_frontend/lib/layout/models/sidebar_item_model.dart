import 'package:flutter/material.dart';

class SidebarModel {
  final String title;
  final int index;
  final String router;
  Widget? icon;
  Widget? iconOnHover;
  String? tooltip;
  final List<SidebarModel> children;

  SidebarModel(
      {required this.title,
      required this.index,
      this.icon,
      this.tooltip,
      this.iconOnHover,
      required this.router,
      this.children = const []}) {
    icon ??= const Icon(Icons.ac_unit);
    iconOnHover ??= const Icon(
      Icons.ac_unit_outlined,
      color: Colors.white,
    );
    tooltip ??= title;
  }
}
