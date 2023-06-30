class MenuAuthResponse {
  int? count;
  List<Records>? records;

  MenuAuthResponse({this.count, this.records});

  MenuAuthResponse.fromJson(Map<String, dynamic> json) {
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
  String? router;

  Records({this.routerId, this.router});

  Records.fromJson(Map<String, dynamic> json) {
    routerId = json['routerId'];
    router = json['router'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['routerId'] = routerId;
    data['router'] = router;
    return data;
  }
}
