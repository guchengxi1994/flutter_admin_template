import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/apis.dart';
import 'package:flutter_admin_template_frontend/common/smart_dialog_utils.dart';
import 'package:flutter_admin_template_frontend/role/role_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/role_detail_response.dart';
import '../models/api_by_router_response.dart' as api_router;
import '../models/api_by_role_response.dart' as api_role;

class ModifyRoleDialog extends ConsumerStatefulWidget {
  const ModifyRoleDialog({super.key, required this.roleId});
  final int roleId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ModifyRoleDialogState();
  }
}

class ModifyRoleDialogState extends ConsumerState<ModifyRoleDialog> {
  late RoleDeailsResponse? _roleDeailsResponse;
  late final TreeNode<AllRouters> tree;

  late Set<int> menus = {};
  late List<api_role.Records> apis = [];

  // ignore: prefer_typing_uninitialized_variables
  var future;

  @override
  void initState() {
    super.initState();
    future = loadData();
  }

  loadData() async {
    _roleDeailsResponse =
        await ref.read(roleProvider).getDetailById(widget.roleId);

    final response = await ref.read(roleProvider).getApiByRoleId(widget.roleId);
    if (response != null) {
      apis = response.records ?? [];
      apiRouters = apis.map((e) => e.apiId ?? -1).toList();
    }

    tree = TreeNode.root();
    if (_roleDeailsResponse != null) {
      menus = (_roleDeailsResponse!.routerIds ?? []).toSet();

      tree.add(TreeNode(
          key: "通用API",
          data: AllRouters(
              parentId: 0,
              router: "commom",
              routerName: "通用API",
              routerId: -1)));
      menus.add(-1);
      final routers =
          List<AllRouters>.from(_roleDeailsResponse!.allRouters ?? []);
      while (routers.isNotEmpty) {
        final i = routers.removeAt(0);
        if (i.parentId == 0) {
          tree.add(TreeNode(key: i.routerName, data: i));
        } else {
          addToTreenode(tree, i);
        }
      }
    }
  }

  addToTreenode(TreeNode<AllRouters> p, AllRouters child) {
    // ignore: no_leading_underscores_for_local_identifiers
    for (final _p in p.childrenAsList) {
      if (((_p as TreeNode).data as AllRouters).routerId == child.parentId) {
        _p.add(TreeNode(key: child.routerName, data: child));
      } else {
        addToTreenode(_p as TreeNode<AllRouters>, child);
      }
    }
  }

  // ignore: unused_field
  late TreeViewController? _controller;

  List<api_router.Records> records = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.close),
            ),
          ),
          Expanded(
              child: Row(
            children: [
              Expanded(flex: 1, child: _buildContent()),
              Expanded(flex: 1, child: _buildApis())
            ],
          )),
          Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
              onPressed: () async {
                await ref
                    .read(roleProvider)
                    .updateRole(widget.roleId, menus.toList(), apiRouters);
              },
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }

  int currentRouterId = -100;

  Widget _buildContent() {
    return FutureBuilder(
      builder: (c, s) {
        if (s.connectionState == ConnectionState.done) {
          if (_roleDeailsResponse == null) {
            return Container();
          }
          return TreeView.simple(
              onTreeReady: (controller) {
                _controller = controller;
                controller.expandAllChildren(tree);
              },
              expansionIndicatorBuilder: (context, node) =>
                  ChevronIndicator.rightDown(
                    tree: node,
                    color: Colors.blue[700],
                    padding: const EdgeInsets.only(top: 22, right: 22),
                  ),
              indentation: const Indentation(style: IndentStyle.squareJoint),
              onItemTap: (item) async {
                var response = await ref
                    .read(roleProvider)
                    .getApiByRouterId(item.data!.routerId!);
                if (response != null) {
                  records = response.records ?? [];
                  setState(() {
                    currentRouterId = item.data!.routerId!;
                  });
                }
              },
              showRootNode: false,
              builder: (ctx, node) {
                String sub = "";
                if (node.children.isNotEmpty) {
                  sub = "( has ${node.children.length} sub menus)";
                }
                return Card(
                  child: ListTile(
                    selected:
                        currentRouterId == (node.data as AllRouters).routerId,
                    leading: GestureDetector(
                      onTap: (node.data as AllRouters).routerId == -1 ||
                              (node.data as AllRouters).routerId == 1
                          ? () => SmartDialogUtils.warning("该路由无法取消")
                          : () {
                              debugPrint("check-box clicked");
                              if (menus.contains(
                                  (node.data as AllRouters).routerId)) {
                                menus
                                    .remove((node.data as AllRouters).routerId);

                                for (final i
                                    in _roleDeailsResponse!.allRouters!) {
                                  if (i.parentId == node.data!.routerId) {
                                    menus.remove(i.routerId);
                                  }
                                }
                              } else {
                                menus.add((node.data as AllRouters).routerId!);
                                for (final i
                                    in _roleDeailsResponse!.allRouters!) {
                                  if (i.parentId == node.data!.routerId) {
                                    menus.add(i.routerId!);
                                  }
                                }
                              }
                              setState(() {});
                            },
                      child: menus.contains((node.data as AllRouters).routerId)
                          ? const Icon(Icons.check_box)
                          : const Icon(Icons.square),
                    ),
                    title:
                        Text((node.data as AllRouters).routerName.toString()),
                    subtitle:
                        Text((node.data as AllRouters).router.toString() + sub),
                  ),
                );
              },
              tree: tree);
        }
        return Container();
      },
      future: future,
    );
  }

  late List<int> apiRouters = [];

  Widget _buildApis() {
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            leading: GestureDetector(
              onTap: () {
                // print(records[index].apiRouter);
                // print(apiRouters.contains(records[index].apiRouter));
                if (reservedApis.contains(records[index].apiRouter)) {
                  SmartDialogUtils.warning("该路由无法取消");
                  return;
                }

                if (apiRouters.contains(records[index].apiId)) {
                  apiRouters.remove(records[index].apiId);
                } else {
                  apiRouters.add(records[index].apiId!);
                }
                setState(() {});
              },
              child: apiRouters.contains(records[index].apiId)
                  ? const Icon(Icons.check_box)
                  : const Icon(Icons.square),
            ),
            title: Text(records[index].apiName ?? ""),
          ),
        );
      },
    );
  }
}
