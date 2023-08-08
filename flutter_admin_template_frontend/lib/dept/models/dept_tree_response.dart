class DepartmentTree {
  int? deptId;
  int? parentId;
  String? deptName;
  int? orderNumber;
  String? createTime;
  String? remark;
  List<DepartmentTree>? children;
  int? level;

  DepartmentTree(
      {this.deptId,
      this.parentId,
      this.deptName,
      this.orderNumber,
      this.createTime,
      this.remark,
      this.children,
      this.level});

  DepartmentTree.fromJson(Map<String, dynamic> json) {
    deptId = json['deptId'];
    parentId = json['parentId'];
    deptName = json['deptName'];
    orderNumber = json['orderNumber'];
    createTime = json['createTime'];
    remark = json['remark'];
    if (json['children'] != null) {
      children = <DepartmentTree>[];
      json['children'].forEach((v) {
        children!.add(DepartmentTree.fromJson(v));
      });
    }
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deptId'] = deptId;
    data['parentId'] = parentId;
    data['deptName'] = deptName;
    data['orderNumber'] = orderNumber;
    data['createTime'] = createTime;
    data['remark'] = remark;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    data['level'] = level;
    return data;
  }
}
