// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/dept/extension.dart';
import 'package:flutter_admin_template_frontend/layout/notifier/sidebar_notifier.dart';
import 'package:flutter_admin_template_frontend/notifier/app_color_notifier.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
    super.dispose();
  }

  // ignore: prefer_typing_uninitialized_variables
  var loadTreeFuture;

  loadTree() async {
    await ref.read(deptProvider).init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadTreeFuture = loadTree();
  }

  late IndexedTreeNode<DepartmentTreeSummary> tree = IndexedTreeNode.root();

  // ignore: unused_field
  late TreeViewController? _controller;

  final ScrollController scrollController = ScrollController();

  late double screenWidth = total;

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
                /*padding*/ 240;
          } else {
            screenWidth = MediaQuery.of(context).size.width -
                AppStyle.sidebarWidth - /*padding*/
                240;
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
  late double total = nameWidth + orderNum + time + operation;

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
                  ? FittedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildAddItemChildButton(node),
                          buildInsertAboveButton(node),
                          buildInsertBelowButton(node),
                          buildRemoveItemButton(node)
                        ],
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildAddItemChildButton(node),
                        if (node.children.isNotEmpty)
                          buildClearAllItemButton(node),
                      ],
                    ),
            ),
          ),
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
        label: const Text("Child", style: TextStyle(color: Colors.green)),
        onPressed: () => item.add(IndexedTreeNode()),
      ),
    );
  }

  Widget buildInsertAboveButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.green[800],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        child:
            const Text("Insert Above", style: TextStyle(color: Colors.green)),
        onPressed: () {
          item.parent?.insertBefore(item, IndexedTreeNode());
        },
      ),
    );
  }

  Widget buildInsertBelowButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.green[800],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        child:
            const Text("Insert Below", style: TextStyle(color: Colors.green)),
        onPressed: () {
          item.parent?.insertAfter(item, IndexedTreeNode());
        },
      ),
    );
  }

  Widget buildRemoveItemButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red[800],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          child: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => item.delete()),
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
          label: const Text("Clear All", style: TextStyle(color: Colors.red)),
          onPressed: () => item.clear()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
