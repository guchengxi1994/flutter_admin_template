import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/notifier/global_notifier.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hovering/hovering.dart';

import '../models/sidebar_item_model.dart';
import '../notifier/sidebar_notifier.dart';

class SidebarItem extends ConsumerWidget {
  const SidebarItem({super.key, required this.model, required this.visible});
  final SidebarModel model;
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
              ref.read(menuAuthProvider).changeRouter(model.router);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 3),
              width: AppStyle.sidebarCollapseWidth - 10,
              height: AppStyle.sidebarCollapseWidth - 10,
              decoration: ref.watch(menuAuthProvider).currentRouter ==
                      model.router
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
                  child: Container(
                    decoration: ref.watch(menuAuthProvider).currentRouter ==
                            model.router
                        ? BoxDecoration(
                            color: AppStyle.hoveringBackgroundColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)))
                        : null,
                    child: ref.watch(menuAuthProvider).currentRouter ==
                            model.router
                        ? model.iconOnHover
                        : model.icon!,
                  ),
                ),
              ),
            ),
          ));
    } else {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            ref.read(menuAuthProvider).changeRouter(model.router);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 3),
            height: AppStyle.sidebarCollapseWidth - 10,
            width: AppStyle.sidebarWidth - 20,
            decoration: ref.watch(menuAuthProvider).currentRouter ==
                    model.router
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
                      ref.watch(menuAuthProvider).currentRouter == model.router
                          ? model.iconOnHover!
                          : model.icon!,
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        model.title,
                        style: ref.watch(menuAuthProvider).currentRouter ==
                                model.router
                            ? const TextStyle(color: Colors.white)
                            : null,
                      )
                    ],
                  ),
                )),
          ),
        ),
      );
    }
  }
}
