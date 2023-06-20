class BaseResponse {
  int? count;
  List? records;

  BaseResponse({required this.count, this.records});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['records'] != null) {
      records = [];
      json['records'].forEach((v) {
        records!.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (records != null) {
      data['records'] = records!.map((v) => v).toList();
    }
    return data;
  }
}
