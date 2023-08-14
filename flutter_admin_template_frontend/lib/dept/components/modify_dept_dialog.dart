import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/dept/extension.dart';
import 'package:flutter_admin_template_frontend/notifier/app_color_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../models/dept_tree_response.dart';

class ModifyDeptModel {
  final String deptName;
  final int parentId;
  final int orderNum;
  final String remark;
  final int deptId;

  ModifyDeptModel(
      {required this.deptName,
      required this.orderNum,
      required this.parentId,
      required this.deptId,
      this.remark = ""});
}

class ModifyDeptDialog extends ConsumerStatefulWidget {
  const ModifyDeptDialog(
      {super.key,
      required this.tree,
      required this.parentName,
      required this.currentId,
      required this.currentParentId});
  final DepartmentTree tree;
  final String parentName;
  final int currentId;
  final int currentParentId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ModifyDeptDialogState();
  }
}

class ModifyDeptDialogState extends ConsumerState<ModifyDeptDialog> {
  late IndexedTreeNode<DepartmentTreeSummary> tree = IndexedTreeNode.root();

  // ignore: unused_field
  late TreeViewController? _controller;

  final JustTheController _justTheController = JustTheController();

  @override
  void initState() {
    super.initState();

    tree = IndexedTreeNode<DepartmentTreeSummary>()
        .buildFromDeptTree(widget.tree)!;

    selectedParentName = widget.parentName;
    selectedParentId = widget.currentParentId;
  }

  String selectedParentName = "";
  int selectedParentId = -1;

  final TextEditingController deptNameController = TextEditingController();
  final TextEditingController orderNumber = TextEditingController();
  final TextEditingController remark = TextEditingController();

  @override
  void dispose() {
    deptNameController.dispose();
    orderNumber.dispose();
    remark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: 600,
      height: 310,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "修改部门",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop(null);
                    },
                    child: const Icon(Icons.close),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              _parentDeptSelection(),
              _newDept(),
              _remark(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                      onPressed: () {
                        final b = _formKey.currentState!.validate();
                        if (b) {
                          ModifyDeptModel model = ModifyDeptModel(
                              deptName: deptNameController.text,
                              orderNum: int.parse(orderNumber.text),
                              parentId: selectedParentId,
                              remark: remark.text,
                              deptId: widget.currentId);
                          Navigator.of(context).pop(model);
                        }
                      },
                      child: const Text("确定"))
                ],
              ),
            ],
          )),
    );
  }

  Widget _parentDeptSelection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _titleWrapper(const Text("父级部门")),
        Expanded(
          child: GestureDetector(
            child: JustTheTooltip(
                onShow: () {
                  // _controller!.collapseNode(tree);
                  collapseAllChildren(tree);
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
                          color: ref.read(colorNotifier).currentColorTheme.$3)),
                  child: TreeView.indexed(
                    expansionIndicatorBuilder: (ctx, node) {
                      return ChevronIndicator.upDown(
                        tree: node,
                        alignment: Alignment.centerLeft,
                      );
                    },
                    indentation:
                        const Indentation(width: 0, style: IndentStyle.none),
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
                            color:
                                ref.read(colorNotifier).currentColorTheme.$3)),
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
      ],
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

  final _formKey = GlobalKey<FormState>();

  final exp = RegExp(r"^[+]{0,1}(\d+)$");

  bool deptNameHasError = false;
  bool numberHasError = false;
  Color errorColor = Colors.redAccent.withAlpha(80);

  Widget _newDept() {
    orderNumber.text = "0";
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _titleWrapper(
          Row(
            children: [
              const Text(("输入名称")),
              Tooltip(
                message: "不能为空",
                child: Icon(Icons.info,
                    color: ref.read(colorNotifier).currentColorTheme.$3),
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                  color: ref.read(colorNotifier).currentColorTheme.$3)),
          height: 40,
          width: 200,
          child: TextFormField(
            decoration: InputDecoration(
                filled: deptNameHasError,
                fillColor: errorColor,
                hintText: "输入部门名",
                border: InputBorder.none,
                counterText: "",
                contentPadding: const EdgeInsets.only(left: 10, bottom: 10)),
            controller: deptNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                setState(() {
                  deptNameHasError = true;
                });
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        _titleWrapper(
          // const Text("输入顺序"),
          Row(
            children: [
              const Text(("输入顺序")),
              Tooltip(
                message: "自然数",
                child: Icon(Icons.info,
                    color: ref.read(colorNotifier).currentColorTheme.$3),
              )
            ],
          ),
        ),
        Container(
          width: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                  color: ref.read(colorNotifier).currentColorTheme.$3)),
          height: 40,
          child: TextFormField(
            decoration: InputDecoration(
              fillColor: errorColor,
              filled: numberHasError,
              contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
              hintText: "输入序号",
              border: InputBorder.none,
              counterText: "",
            ),
            controller: orderNumber,
            validator: (value) {
              if (value == null || value.isEmpty) {
                // return 'Empty';
                setState(() {
                  numberHasError = true;
                });
              }
              final r = exp.hasMatch(value!);
              if (!r) {
                setState(() {
                  numberHasError = true;
                });
              }
              return null;
            },
          ),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: Column(
            children: [
              Expanded(
                  child: Center(
                child: InkWell(
                    onTap: () {
                      int? d = int.tryParse(orderNumber.text);
                      if (d != null) {
                        orderNumber.text = (d + 1).toString();
                      }
                    },
                    child: const Icon(Icons.add)),
              )),
              Expanded(
                  child: Center(
                child: InkWell(
                    onTap: () {
                      int? d = int.tryParse(orderNumber.text);
                      if (d != null && d >= 1) {
                        orderNumber.text = (d - 1).toString();
                      }
                    },
                    child: const Icon(Icons.remove)),
              ))
            ],
          ),
        )
      ],
    );
  }

  Widget _titleWrapper(Widget child) {
    return SizedBox(
      height: 60,
      width: 100,
      child: Align(
        alignment: Alignment.centerLeft,
        child: child,
      ),
    );
  }

  Widget _remark() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _titleWrapper(const Text("备注")),
        Expanded(
            child: Container(
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                  color: ref.read(colorNotifier).currentColorTheme.$3)),
          child: TextField(
              controller: remark,
              decoration: InputDecoration(
                fillColor: errorColor,
                filled: numberHasError,
                contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
                hintText: "输入备注",
                border: InputBorder.none,
                counterText: "",
              )),
        ))
      ],
    );
  }

  void collapseAllChildren(ITreeNode node) {
    _controller!.collapseNode(node);
    for (final child in node.childrenAsList) {
      // expandNode(child as Tree);
      _controller!.collapseNode(child as ITreeNode);
      if (child.childrenAsList.isNotEmpty) collapseAllChildren(child);
    }
  }
}
