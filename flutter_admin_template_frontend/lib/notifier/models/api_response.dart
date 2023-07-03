class ApiResponse {
  int? count;
  List<Records>? records;

  ApiResponse({this.count, this.records});

  ApiResponse.fromJson(Map<String, dynamic> json) {
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
  int? apiId;
  String? apiName;
  String? apiRouter;
  String? apiMethod;

  Records({this.apiId, this.apiName, this.apiRouter, this.apiMethod});

  Records.fromJson(Map<String, dynamic> json) {
    apiId = json['apiId'];
    apiName = json['apiName'];
    apiRouter = json['apiRouter'];
    apiMethod = json['apiMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['apiId'] = apiId;
    data['apiName'] = apiName;
    data['apiRouter'] = apiRouter;
    data['apiMethod'] = apiMethod;
    return data;
  }
}
