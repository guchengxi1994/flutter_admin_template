class UpdateRoleRequest {
  int? roleId;
  List<int>? routers;
  List<int>? apis;

  UpdateRoleRequest({this.roleId, this.routers, this.apis});

  UpdateRoleRequest.fromJson(Map<String, dynamic> json) {
    roleId = json['roleId'];
    routers = json['routers'].cast<int>();
    apis = json['apis'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roleId'] = roleId;
    data['routers'] = routers;
    data['apis'] = apis;
    return data;
  }
}
