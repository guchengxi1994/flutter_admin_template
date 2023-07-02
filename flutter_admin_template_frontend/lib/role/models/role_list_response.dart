class RoleListResponse {
  int? count;
  List<Records>? records;

  RoleListResponse({this.count, this.records});

  RoleListResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (records != null) {
      data['records'] = records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Records {
  int? roleId;
  String? roleName;
  String? createTime;
  String? updateTime;
  String? remark;

  Records(
      {this.roleId,
      this.roleName,
      this.createTime,
      this.updateTime,
      this.remark});

  Records.fromJson(Map<String, dynamic> json) {
    roleId = json['roleId'];
    roleName = json['roleName'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roleId'] = roleId;
    data['roleName'] = roleName;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['remark'] = remark;
    return data;
  }
}
