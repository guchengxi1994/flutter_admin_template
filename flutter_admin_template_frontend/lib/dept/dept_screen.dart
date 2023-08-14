// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/dept/components/modify_dept_dialog.dart';
import 'package:flutter_admin_template_frontend/dept/extension.dart';
import 'package:flutter_admin_template_frontend/layout/notifier/sidebar_notifier.dart';
import 'package:flutter_admin_template_frontend/notifier/app_color_notifier.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'components/dept_detail_dialog.dart';
import 'components/new_dept_dialog.dart';
import 'components/popup_menu.dart';
import 'dept_notifier.dart';

class DeptScreen extends ConsumerStatefulWidget {
  const DeptScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DeptScreenState();
  }
}

class DeptScreenState extends ConsumerState<DeptScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    scrollController.dispose();
    searchStringController.dispose();
    super.dispose();
  }

  // ignore: prefer_typing_uninitialized_variables
  var loadTreeFuture;

  loadTree() async {
    debugPrint("[flutter] dept repaint here");
    await ref.read(deptProvider).init();
  }

  @override
  void initState() {
    super.initState();
    loadTreeFuture = loadTree();
  }

  late IndexedTreeNode<DepartmentTreeSummary> tree = IndexedTreeNode.root();

  // ignore: unused_field
  late TreeViewController? _controller;

  final ScrollController scrollController = ScrollController();

  late double screenWidth = total;

  final searchStringController = TextEditingController();

  Widget _search() {
    return Container(
      padding: const EdgeInsets.all(5),
      width: 180,
      height: 30,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(19)),
          border: Border.all(color: const Color.fromARGB(255, 232, 232, 232))),
      child: TextField(
        controller: searchStringController,
        onChanged: (value) {},
        style: const TextStyle(
            color: Color.fromARGB(255, 159, 159, 159), fontSize: 12),
        decoration: const InputDecoration(
          hintStyle: TextStyle(
              color: Color.fromARGB(255, 159, 159, 159), fontSize: 12),
          contentPadding: EdgeInsets.only(left: 10, bottom: 15),
          hintText: "输入部门名称",
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: loadTreeFuture,
      builder: (c, s) {
        if (s.connectionState == ConnectionState.done) {
          if (ref.read(sidebarProvider).isCollapse) {
            screenWidth = MediaQuery.of(context).size.width -
                AppStyle.sidebarCollapseWidth -
                /*padding*/ AppStyle.submenuWidth -
                30;
          } else {
            screenWidth = MediaQuery.of(context).size.width -
                AppStyle.sidebarWidth - /*padding*/
                AppStyle.submenuWidth -
                30;
          }
          if (ref.read(deptProvider).tree != null) {
            tree = IndexedTreeNode<DepartmentTreeSummary>()
                    .buildFromDeptTree(ref.read(deptProvider).tree) ??
                IndexedTreeNode<DepartmentTreeSummary>();
            return RawScrollbar(
                controller: scrollController,
                child: SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: screenWidth > total ? screenWidth : total,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _search(),
                                const SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () {}, child: const Text("检索"))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _tableColumn(),
                          Expanded(
                            child: TreeView.indexed<DepartmentTreeSummary>(
                              expansionIndicatorBuilder: (ctx, node) {
                                return ChevronIndicator.upDown(
                                  tree: node,
                                  alignment: Alignment.centerLeft,
                                );
                              },
                              indentation: const Indentation(
                                  width: 0, style: IndentStyle.none),
                              onTreeReady: (controller) {
                                _controller = controller;
                                controller.expandAllChildren(tree);
                              },
                              builder: _buildContent,
                              tree: tree,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  static const double indent = 30;
  static const double nameWidth = 500;
  static const double orderNum = 100;
  static const double time = 300;
  static const double operation = 300;
  static const double extraOperation = 50;
  late double total = nameWidth + orderNum + time + operation + extraOperation;

  Widget _tableColumn() {
    return Container(
      height: 50,
      width: screenWidth > total ? screenWidth : total,
      // width: total,
      decoration: BoxDecoration(
          color: ref.watch(colorNotifier).currentColorTheme.$4,
          border: Border(
              bottom: BorderSide(
                  color: ref.watch(colorNotifier).currentColorTheme.$1))),
      child: Row(
        children: [
          SizedBox(
            width: nameWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Name", style: AppStyle.tableColumnStyle),
            ),
          ),
          SizedBox(
            width: orderNum,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Order", style: AppStyle.tableColumnStyle),
            ),
          ),
          SizedBox(
            width: time,
            child: Align(
              alignment: Alignment.center,
              child: Text("Create Time", style: AppStyle.tableColumnStyle),
            ),
          ),
          Expanded(
            // width: operation,
            child: Align(
              alignment: Alignment.center,
              child: Text("Operation", style: AppStyle.tableColumnStyle),
            ),
          ),
          const SizedBox(
            width: extraOperation,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, IndexedTreeNode<DepartmentTreeSummary> node) {
    return Container(
      height: 45,
      width: screenWidth > total ? screenWidth : total,
      // width: total,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: ref.watch(colorNotifier).currentColorTheme.$1))),
      child: Row(
        children: [
          SizedBox(
            width: nameWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: (node.level + 1) * indent),
                child: Text(
                  node.data?.deptName ?? '',
                  style: AppStyle.itemStyle,
                ),
              ),
            ),
          ),
          SizedBox(
            width: orderNum,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                node.data?.orderNumber?.toString() ?? "0",
                style: AppStyle.itemStyle,
              ),
            ),
          ),
          SizedBox(
            width: time,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                DateFormat("yyyy-MM-dd HH:mm:ss").format(
                    DateTime.parse(node.data!.createTime.toString()).toLocal()),
                style: AppStyle.itemStyle,
              ),
            ),
          ),
          Expanded(
            // width: operation,

            child: Align(
              alignment: Alignment.center,
              child: !node.isRoot
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildAddItemChildButton(node),
                        // buildRemoveItemButton(node)
                        buildModifyItemButton(node)
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildAddItemChildButton(node),
                        buildModifyItemButton(node)
                        // if (node.children.isNotEmpty)
                        //   buildClearAllItemButton(node),
                      ],
                    ),
            ),
          ),
          SizedBox(
            child: TabllePopupMenu(
              onDetails: () async {
                final d = await ref
                    .read(deptProvider)
                    .querySingleById(node.data!.deptId!);
                if (d != null) {
                  // ignore: use_build_context_synchronously
                  showGeneralDialog(
                      context: context,
                      pageBuilder: (c, a, b) {
                        return Center(
                          child: DeptDetailDialog(
                            response: d,
                          ),
                        );
                      });
                }
              },
              isRoot: node.isRoot,
            ),
          )
        ],
      ),
    );
  }

  Widget buildAddItemChildButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.green[800],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        icon: const Icon(Icons.add_circle, color: Colors.green),
        label: screenWidth < total
            ? const Text("")
            : const Text("Add Sub Dept", style: TextStyle(color: Colors.green)),
        onPressed: () async {
          // item.add(IndexedTreeNode());
          if (ref.read(deptProvider).tree != null) {
            final r = await showGeneralDialog(
                context: context,
                pageBuilder: (c, a, b) {
                  return Center(
                    child: NewDeptDialog(
                      // tree: ref.read(deptProvider).tree!,
                      parentName: item.data.deptName,
                    ),
                  );
                });
            if (r != null) {}
          }
        },
      ),
    );
  }

  Widget buildInsertAboveButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.green[800],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        icon: SizedBox(
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            "assets/icons/ainsert.svg",
            // color: Colors.green,
            colorFilter:
                const ColorFilter.mode(Colors.green, ui.BlendMode.srcIn),
          ),
        ),
        label: screenWidth < total
            ? const Text("")
            : const Text("Insert Above", style: TextStyle(color: Colors.green)),
        onPressed: () {
          // item.parent?.insertBefore(item, IndexedTreeNode());
        },
      ),
    );
  }

  Widget buildInsertBelowButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.green[800],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        icon: SizedBox(
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            "assets/icons/binsert.svg",
            // theme: const SvgTheme(currentColor: Colors.green),
            colorFilter:
                const ColorFilter.mode(Colors.green, ui.BlendMode.srcIn),
          ),
        ),
        label: screenWidth < total
            ? const Text("")
            : const Text("Insert Below", style: TextStyle(color: Colors.green)),
        onPressed: () {
          // item.parent?.insertAfter(item, IndexedTreeNode());
        },
      ),
    );
  }

  Widget buildRemoveItemButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red[800],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          icon: const Icon(Icons.delete, color: Colors.red),
          label: screenWidth < total
              ? const Text("")
              : const Text("Delete", style: TextStyle(color: Colors.red)),
          onPressed: () {
            // item.delete();
          }),
    );
  }

  Widget buildClearAllItemButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red[800],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          icon: const Icon(Icons.delete, color: Colors.red),
          label: screenWidth < total
              ? const Text("")
              : const Text("Delete All", style: TextStyle(color: Colors.red)),
          onPressed: () {
            // item.clear();
          }),
    );
  }

  Widget buildModifyItemButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green[800],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          icon: const Icon(Icons.change_circle, color: Colors.green),
          label: screenWidth < total
              ? const Text("")
              : const Text("Modify", style: TextStyle(color: Colors.green)),
          onPressed: () async {
            final _tree =
                await ref.read(deptProvider).getWithout(item.data.deptId);

            if (_tree != null) {
              // ignore: use_build_context_synchronously
              final r = await showGeneralDialog(
                  context: context,
                  pageBuilder: (c, a, b) {
                    return Center(
                      child: ModifyDeptDialog(
                        tree: _tree,
                        // tree: ref.read(deptProvider).tree!,
                        parentName: item.data.deptName,
                        currentId: item.data.deptId,
                        currentParentId: item.data.parentId,
                      ),
                    );
                  });
              if (r != null) {}
            }

            // item.clear();
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
