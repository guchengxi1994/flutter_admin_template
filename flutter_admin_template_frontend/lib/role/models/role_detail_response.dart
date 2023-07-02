class RoleDeailsResponse {
  List<int>? routerIds;
  List<AllRouters>? allRouters;

  RoleDeailsResponse({this.routerIds, this.allRouters});

  RoleDeailsResponse.fromJson(Map<String, dynamic> json) {
    routerIds = json['routerIds'].cast<int>();
    if (json['allRouters'] != null) {
      allRouters = <AllRouters>[];
      json['allRouters'].forEach((v) {
        allRouters!.add(AllRouters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['routerIds'] = routerIds;
    if (allRouters != null) {
      data['allRouters'] = allRouters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllRouters {
  int? routerId;
  String? router;
  String? routerName;
  int? parentId;

  AllRouters({this.routerId, this.router, this.routerName, this.parentId});

  AllRouters.fromJson(Map<String, dynamic> json) {
    routerId = json['routerId'];
    router = json['router'];
    routerName = json['routerName'];
    parentId = json['parentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['routerId'] = routerId;
    data['router'] = router;
    data['routerName'] = routerName;
    data['parentId'] = parentId;
    return data;
  }
}
