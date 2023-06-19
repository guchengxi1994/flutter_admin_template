import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/layout/models/sidebar_item_model.dart';
import 'package:flutter_admin_template_frontend/layout/notifier/sidebar_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hovering/hovering.dart';
import 'dart:math' as math;

import '../../notifier/global_notifier.dart';
import '../../styles/app_style.dart';

// ValueNotifier<bool> subVisible = ValueNotifier(false);

class SidebarItemWithChildren extends ConsumerWidget {
  const SidebarItemWithChildren(
      {super.key,
      required this.model,
      required this.visible,
      required this.subVisible});
  final SidebarModel model;
  final bool visible;
  final ValueNotifier<bool> subVisible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
        valueListenable: subVisible,
        builder: (ctx, d, w) {
          if (ref.watch(sidebarProvider).isCollapse) {
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)))
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
                          decoration:
                              ref.watch(menuAuthProvider).currentRouter ==
                                      model.router
                                  ? BoxDecoration(
                                      color: AppStyle.hoveringBackgroundColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)))
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
          }

          if (!subVisible.value) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  // ref.read(menuAuthProvider).changeRouter(model.router);
                  subVisible.value = true;
                  ref.read(menuAuthProvider).changeRouter(model.router);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 3),
                  height: AppStyle.sidebarCollapseWidth - 10,
                  width: AppStyle.sidebarWidth - 20,
                  decoration:
                      ref.watch(menuAuthProvider).currentRouter == model.router
                          ? BoxDecoration(
                              color: AppStyle.hoveringBackgroundColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)))
                          : null,
                  child: HoverWidget(
                      hoverChild: Container(
                        decoration: BoxDecoration(
                            color: AppStyle.hoveringBackgroundColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
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
                            ),
                            const Expanded(child: SizedBox()),
                            Transform.rotate(
                              angle: math.pi / 2,
                              child: const Icon(Icons.chevron_right,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      onHover: (v) {},
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            ref.watch(menuAuthProvider).currentRouter ==
                                    model.router
                                ? model.iconOnHover!
                                : model.icon!,
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              model.title,
                              style:
                                  ref.watch(menuAuthProvider).currentRouter ==
                                          model.router
                                      ? const TextStyle(color: Colors.white)
                                      : null,
                            ),
                            const Expanded(child: SizedBox()),
                            Transform.rotate(
                              angle: math.pi / 2,
                              child: Icon(
                                Icons.chevron_right,
                                color:
                                    ref.watch(menuAuthProvider).currentRouter ==
                                            model.router
                                        ? Colors.white
                                        : null,
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ),
            );
          } else {
            return Column(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(menuAuthProvider).changeRouter(model.router);
                      subVisible.value = false;
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 3),
                      height: AppStyle.sidebarCollapseWidth - 10,
                      width: AppStyle.sidebarWidth - 20,
                      decoration: ref.watch(menuAuthProvider).currentRouter ==
                              model.router
                          ? BoxDecoration(
                              color: AppStyle.hoveringBackgroundColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)))
                          : null,
                      child: HoverWidget(
                          hoverChild: Container(
                            decoration: BoxDecoration(
                                color: AppStyle.hoveringBackgroundColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
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
                                ),
                                const Expanded(child: SizedBox()),
                                Transform.rotate(
                                  angle: math.pi / 2,
                                  child: const Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onHover: (v) {},
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                ref.watch(menuAuthProvider).currentRouter ==
                                        model.router
                                    ? model.iconOnHover!
                                    : model.icon!,
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  model.title,
                                  style: ref
                                              .watch(menuAuthProvider)
                                              .currentRouter ==
                                          model.router
                                      ? const TextStyle(color: Colors.white)
                                      : null,
                                ),
                                const Expanded(child: SizedBox()),
                                Transform.rotate(
                                  angle: math.pi / 2,
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: ref
                                                .watch(menuAuthProvider)
                                                .currentRouter ==
                                            model.router
                                        ? Colors.white
                                        : null,
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
                ..._buildChildren(ref)
              ],
            );
          }
        });
  }

  List<Widget> _buildChildren(WidgetRef ref) {
    List<Widget> result = [];
    for (final i in model.children) {
      final r = i.router;
      int count = r.split("/").length - 3;
      result.add(
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              ref.read(menuAuthProvider).changeRouter(i.router);
            },
            child: Container(
              margin: EdgeInsets.only(top: 3, left: count * 20, right: 10),
              height: AppStyle.sidebarCollapseWidth - 10,
              // width: AppStyle.sidebarWidth - 20,
              decoration: ref.watch(menuAuthProvider).currentRouter == i.router
                  ? BoxDecoration(
                      color: AppStyle.hoveringBackgroundColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8)))
                  : null,
              child: HoverWidget(
                  hoverChild: Container(
                    decoration: BoxDecoration(
                        color: AppStyle.hoveringBackgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        i.iconOnHover!,
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          i.title,
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
                        ref.watch(menuAuthProvider).currentRouter == i.router
                            ? i.iconOnHover!
                            : i.icon!,
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          i.title,
                          style: ref.watch(menuAuthProvider).currentRouter ==
                                  i.router
                              ? const TextStyle(color: Colors.white)
                              : null,
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ),
      );
    }

    return result;
  }
}
