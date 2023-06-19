import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/notifier/global_notifier.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hovering/hovering.dart';

import '../models/sidemenu_item_model.dart';
import '../notifier/sidebar_notifier.dart';

class SidebarItem extends ConsumerWidget {
  const SidebarItem({super.key, required this.model, required this.visible});
  final SidemenuModel model;
  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isCollapse = ref.watch(sidebarProvider).isCollapse;
    return Visibility(visible: visible, child: _buildItem(isCollapse, ref));
  }

  Widget _buildItem(bool isCollapse, WidgetRef ref) {
    if (isCollapse) {
      return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              ref.read(menuAuthProvider).changeIndex(model.index);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 3),
              width: AppStyle.sidebarCollapseWidth - 10,
              height: AppStyle.sidebarCollapseWidth - 10,
              decoration: ref.watch(menuAuthProvider).currentPageIndex ==
                      model.index
                  ? BoxDecoration(
                      color: AppStyle.hoveringBackgroundColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8)))
                  : null,
              child: Tooltip(
                message: model.tooltip,
                child: HoverWidget(
                  hoverChild: Container(
                    decoration: BoxDecoration(
                        color: AppStyle.hoveringBackgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: model.iconOnHover!,
                  ),
                  onHover: (v) {},
                  child: Container(child: model.icon!),
                ),
              ),
            ),
          ));
    } else {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            ref.read(menuAuthProvider).changeIndex(model.index);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 3),
            height: AppStyle.sidebarCollapseWidth - 10,
            width: AppStyle.sidebarWidth - 20,
            decoration: ref.watch(menuAuthProvider).currentPageIndex ==
                    model.index
                ? BoxDecoration(
                    color: AppStyle.hoveringBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8)))
                : null,
            child: HoverWidget(
                hoverChild: Container(
                  decoration: BoxDecoration(
                      color: AppStyle.hoveringBackgroundColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      model.iconOnHover!,
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        model.title,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                onHover: (v) {},
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      model.icon!,
                      const SizedBox(
                        width: 10,
                      ),
                      Text(model.title)
                    ],
                  ),
                )),
          ),
        ),
      );
    }
  }
}
