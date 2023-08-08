import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/dept/extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dept_notifier.dart';

class DeptScreen extends ConsumerStatefulWidget {
  const DeptScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DeptScreenState();
  }
}

class DeptScreenState extends ConsumerState<DeptScreen> {
  @override
  void initState() {
    super.initState();
    loadTreeFuture = ref.read(deptProvider).init();
  }

  // ignore: prefer_typing_uninitialized_variables
  var loadTreeFuture;

  late IndexedTreeNode<DepartmentTreeSummary> tree = IndexedTreeNode.root();

  // ignore: unused_field
  late TreeViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadTreeFuture,
        builder: (c, s) {
          if (s.connectionState == ConnectionState.done) {
            if (ref.read(deptProvider).tree != null) {
              tree = IndexedTreeNode<DepartmentTreeSummary>()
                      .buildFromDeptTree(ref.read(deptProvider).tree) ??
                  IndexedTreeNode<DepartmentTreeSummary>();
              return TreeView.indexed<DepartmentTreeSummary>(
                onTreeReady: (controller) {
                  _controller = controller;
                  controller.expandAllChildren(tree);
                },
                builder: _buildContent,
                tree: tree,
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget _buildContent(
      BuildContext context, IndexedTreeNode<DepartmentTreeSummary> node) {
    final double nameWidth = 200 - node.level * 19;

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              title: Row(
                children: [
                  Container(
                    color: Colors.lightBlue,
                    width: nameWidth,
                    child: Text(
                      node.data?.deptName ?? '',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
              // subtitle: Text(
              //   'Level ${node.level}',
              //   style: TextStyle(color: Colors.black),
              // ),
              trailing: !node.isRoot ? buildRemoveItemButton(node) : null,
            ),
            if (!node.isRoot)
              FittedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildAddItemChildButton(node),
                    buildInsertAboveButton(node),
                    buildInsertBelowButton(node),
                  ],
                ),
              ),
            if (node.isRoot)
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildAddItemChildButton(node),
                  if (node.children.isNotEmpty) buildClearAllItemButton(node),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildAddItemChildButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.green[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        icon: Icon(Icons.add_circle, color: Colors.green),
        label: Text("Child", style: TextStyle(color: Colors.green)),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        child: Text("Insert Above", style: TextStyle(color: Colors.green)),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        child: Text("Insert Below", style: TextStyle(color: Colors.green)),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          child: Icon(Icons.delete, color: Colors.red),
          onPressed: () => item.delete()),
    );
  }

  Widget buildClearAllItemButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          icon: Icon(Icons.delete, color: Colors.red),
          label: Text("Clear All", style: TextStyle(color: Colors.red)),
          onPressed: () => item.clear()),
    );
  }
}
