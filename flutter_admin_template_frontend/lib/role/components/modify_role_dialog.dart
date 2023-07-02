import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/role/role_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/role_detail_response.dart';

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
    tree = TreeNode.root();
    if (_roleDeailsResponse != null) {
      menus = (_roleDeailsResponse!.routerIds ?? []).toSet();

      final routers = _roleDeailsResponse!.allRouters ?? [];
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
          Expanded(child: _buildContent())
        ],
      ),
    );
  }

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
              onItemTap: (item) {},
              showRootNode: false,
              builder: (ctx, node) {
                String sub = "";
                if (node.children.isNotEmpty) {
                  sub = "( has ${node.children.length} sub menus)";
                }
                return Card(
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        debugPrint("check-box clicked");
                        if (menus
                            .contains((node.data as AllRouters).routerId)) {
                          menus.remove((node.data as AllRouters).routerId);
                        } else {
                          menus.add((node.data as AllRouters).routerId!);
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
}
