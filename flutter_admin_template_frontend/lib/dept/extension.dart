import 'package:animated_tree_view/animated_tree_view.dart';

import 'models/dept_tree_response.dart';

class DepartmentTreeSummary {
  int? deptId;
  int? parentId;
  String? deptName;
  int? orderNumber;
  String? createTime;
  String? remark;

  DepartmentTreeSummary({
    this.deptId,
    this.parentId,
    this.deptName,
    this.orderNumber,
    this.createTime,
    this.remark,
  });
}

extension Summary on DepartmentTree {
  DepartmentTreeSummary summary() {
    return DepartmentTreeSummary(
        deptId: deptId,
        parentId: parentId,
        deptName: deptName,
        orderNumber: orderNumber,
        createTime: createTime,
        remark: remark);
  }
}

extension BuildTree on IndexedTreeNode {
  IndexedTreeNode<DepartmentTreeSummary>? buildFromDeptTree(
      DepartmentTree? tree) {
    if (tree == null) {
      return null;
    }

    var root = IndexedTreeNode.root(data: tree.summary());

    root = _buildTree(root, tree);
    return root;
  }
}

IndexedTreeNode<DepartmentTreeSummary> _buildTree(
    IndexedTreeNode<DepartmentTreeSummary> node, DepartmentTree tree) {
  for (final i in tree.children!) {
    final n = _buildTree(IndexedTreeNode(data: i.summary()), i);
    node.add(n);
  }

  return node;
}
