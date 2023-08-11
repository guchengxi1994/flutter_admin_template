import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/layout/notifier/sidebar_notifier.dart';
import 'package:flutter_admin_template_frontend/notifier/app_color_notifier.dart';
import 'package:flutter_admin_template_frontend/routers.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_admin_template_frontend/styles/theme/color_theme.dart';
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
      decoration: BoxDecoration(
        color: ref.watch(colorNotifier).currentColorTheme.$1,
      ),
      initialIndex: ref.watch(menuAuthProvider).currentRouterId,
      onExpansionChanged: (p0) {
        ref.read(sidebarProvider).changeIsCollapse(p0);
      },
      body: widget.body,
      errWidget: TextButton(
        child: const Text("Log out"),
        onPressed: () {
          Navigator.of(context).popAndPushNamed(FatRouters.loginScreen);
        },
      ),
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
      trailing: InkWell(
        onTap: () async {
          final colors = ColorTheme().baseColors;

          // Make a custom ColorSwatch to name map from the above custom colors.
          final Map<ColorSwatch<Object>, String> colorsNameMap =
              <ColorSwatch<Object>, String>{
            ColorTools.createPrimarySwatch(colors[0]): 'Dark',
            ColorTools.createPrimarySwatch(colors[1]): 'Light',
            ColorTools.createAccentSwatch(colors[2]): 'Light grey',
            ColorTools.createAccentSwatch(colors[3]): 'Dark orange ',
            ColorTools.createPrimarySwatch(colors[4]): 'Orange',
            ColorTools.createPrimarySwatch(colors[5]): 'Dark green',
            ColorTools.createPrimarySwatch(colors[6]): 'Light grey',
          };

          // ignore: deprecated_member_use_from_same_package
          Color c = AppStyle.appBlue;

          final r = await ColorPicker(
            pickersEnabled: const <ColorPickerType, bool>{
              ColorPickerType.both: false,
              ColorPickerType.primary: false,
              ColorPickerType.accent: false,
              ColorPickerType.bw: false,
              ColorPickerType.custom: true,
              ColorPickerType.wheel: false,
            },
            enableShadesSelection: false,
            customColorSwatchesAndNames: colorsNameMap,
            onColorChanged: (value) {
              // print(value);
              c = value;
            },
          ).showPickerDialog(context, transitionBuilder: (BuildContext context,
                  Animation<double> a1, Animation<double> a2, Widget widget) {
            final double curvedValue =
                Curves.easeInOutBack.transform(a1.value) - 1.0;
            return Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
              child: Opacity(
                opacity: a1.value,
                child: widget,
              ),
            );
          },
              transitionDuration: const Duration(milliseconds: 400),
              constraints: const BoxConstraints(
                  minHeight: 100, minWidth: 400, maxWidth: 400));

          if (r) {
            ref.read(colorNotifier).changeCurrent(c);
          }
        },
        child: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ),
    );
  }
}
