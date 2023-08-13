import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/dept/extension.dart';
import 'package:flutter_admin_template_frontend/notifier/app_color_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../models/dept_tree_response.dart';

class NewDeptDialog extends ConsumerStatefulWidget {
  const NewDeptDialog({super.key, this.tree, this.parentName})
      : assert(tree != null || parentName != null);
  final DepartmentTree? tree;
  final String? parentName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return NewDeptDialogState();
  }
}

class NewDeptDialogState extends ConsumerState<NewDeptDialog> {
  late IndexedTreeNode<DepartmentTreeSummary> tree = IndexedTreeNode.root();

  // ignore: unused_field
  late TreeViewController? _controller;

  final JustTheController _justTheController = JustTheController();

  @override
  void initState() {
    super.initState();
    if (widget.tree != null) {
      tree = IndexedTreeNode<DepartmentTreeSummary>()
          .buildFromDeptTree(widget.tree)!;
    }
  }

  String selectedParentName = "";
  int selectedParentId = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: 550,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "新建部门",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Expanded(child: SizedBox()),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _titleWrapper(const Text("父级部门")),
              if (widget.tree != null)
                Expanded(
                  child: GestureDetector(
                    child: JustTheTooltip(
                        onShow: () {
                          _controller!.collapseNode(tree);
                        },
                        onDismiss: () {
                          setState(() {});
                        },
                        controller: _justTheController,
                        offset: -15,
                        tailBuilder: (point1, point2, point3) {
                          return Path()
                            ..moveTo(point1.dx, point1.dy)
                            ..lineTo(point3.dx, point3.dy)
                            ..close();
                        },
                        isModal: true,
                        content: Container(
                          width: 420,
                          height: 300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: ref
                                      .read(colorNotifier)
                                      .currentColorTheme
                                      .$3)),
                          child: TreeView.indexed(
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
                              // controller.expandAllChildren(tree);
                            },
                            builder: _buildContent,
                            tree: tree,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                    color: ref
                                        .read(colorNotifier)
                                        .currentColorTheme
                                        .$3)),
                            height: 40,
                            child: SizedBox.expand(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(selectedParentName),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              if (widget.parentName != null)
                Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              color: ref
                                  .read(colorNotifier)
                                  .currentColorTheme
                                  .$3)),
                      height: 40,
                      // child: Text(widget.parentName.toString()),
                      child: SizedBox.expand(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(widget.parentName.toString()),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, IndexedTreeNode<DepartmentTreeSummary> node) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        side: MaterialStateProperty.all(BorderSide.none),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      ),
      onPressed: () {
        selectedParentName = node.data!.deptName.toString();
        selectedParentId = node.data!.parentId ?? -1;
        _justTheController.hideTooltip();
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: (node.level + 1) * 20,
        ),
        child: SizedBox(
          height: 30,
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(node.data!.deptName.toString())),
        ),
      ),
    );
  }

  Widget _titleWrapper(Widget child) {
    return SizedBox(
      height: 60,
      width: 100,
      child: Center(
        child: child,
      ),
    );
  }
}
