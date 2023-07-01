class AllRouterResponse {
  int? count;
  List<Records>? records;

  AllRouterResponse({this.count, this.records});

  AllRouterResponse.fromJson(Map<String, dynamic> json) {
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
  int? routerId;
  String? routerName;
  String? router;
  String? createTime;
  String? updateTime;
  String? remark;
  int? parentId;

  Records(
      {this.routerId,
      this.routerName,
      this.router,
      this.createTime,
      this.updateTime,
      this.remark,
      this.parentId});

  Records.fromJson(Map<String, dynamic> json) {
    routerId = json['routerId'];
    routerName = json['routerName'];
    router = json['router'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    remark = json['remark'];
    parentId = json['parentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['routerId'] = routerId;
    data['routerName'] = routerName;
    data['router'] = router;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['remark'] = remark;
    data['parentId'] = parentId;
    return data;
  }
}
