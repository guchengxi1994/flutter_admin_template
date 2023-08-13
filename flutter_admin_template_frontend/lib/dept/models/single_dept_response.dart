class SingleDepartmentResponse {
  int? deptId;
  String? parentDeptName;
  String? deptName;
  int? orderNumber;
  String? createTime;
  String? remark;

  SingleDepartmentResponse(
      {this.deptId,
      this.parentDeptName,
      this.deptName,
      this.orderNumber,
      this.createTime,
      this.remark});

  SingleDepartmentResponse.fromJson(Map<String, dynamic> json) {
    deptId = json['deptId'];
    parentDeptName = json['parentDeptName'];
    deptName = json['deptName'];
    orderNumber = json['orderNumber'];
    createTime = json['createTime'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deptId'] = deptId;
    data['parentDeptName'] = parentDeptName;
    data['deptName'] = deptName;
    data['orderNumber'] = orderNumber;
    data['createTime'] = createTime;
    data['remark'] = remark;
    return data;
  }
}
