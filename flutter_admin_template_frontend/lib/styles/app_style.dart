import 'package:flutter/material.dart';

part './login.dart';
part 'sidebar.dart';
part 'table.dart';

class AppStyle {
  AppStyle._();

  static const Color appBlue = Color.fromARGB(193, 15, 84, 188);

  static double get loginLogoHeight => _LoginScreenStyle.logoHeight;
  static double get loginLogoFontSize => _LoginScreenStyle.logoFontSize;
  static Color get loginLogoColor => _LoginScreenStyle.logoColor;
  static Color get loginBackgroundColor1 => _LoginScreenStyle.backgroundColor1;
  static Color get loginBackgroundColor2 => _LoginScreenStyle.backgroundColor2;
  static Color get loginLightgrey1 => _LoginScreenStyle.lightGrey;
  static Color get loginLightgrey2 => _LoginScreenStyle.lightGrey2;

  static double get sidebarWidth => _SidebarStyle.sidebarWidth;
  static double get sidebarCollapseWidth => _SidebarStyle.sidebarCollapseWidth;
  static Color get hoveringBackgroundColor =>
      _SidebarStyle.hoveringBackgroundColor;
  static double get sidebarHeaderHeight => _SidebarStyle.sidebarHeaderHeight;

  static TextStyle get tableColumnStyle => _TableStyle.columnStyle;
  static TextStyle get itemStyle => _TableStyle.itemStyle;
}
