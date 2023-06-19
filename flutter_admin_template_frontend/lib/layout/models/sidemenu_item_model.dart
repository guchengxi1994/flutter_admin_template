import 'package:flutter/material.dart';

class SidemenuModel {
  final String title;
  final int index;
  final String router;
  Widget? icon;
  Widget? iconOnHover;
  String? tooltip;

  SidemenuModel(
      {required this.title,
      required this.index,
      this.icon,
      this.tooltip,
      this.iconOnHover,
      required this.router}) {
    icon ??= const Icon(Icons.ac_unit);
    iconOnHover ??= const Icon(
      Icons.ac_unit_outlined,
      color: Colors.white,
    );
    tooltip ??= title;
  }
}
