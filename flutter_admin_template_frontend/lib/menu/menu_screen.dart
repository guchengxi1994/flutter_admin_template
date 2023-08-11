import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/common/platform_utils.dart';
import 'package:flutter_admin_template_frontend/notifier/global_notifier.dart';
import 'package:flutter_admin_template_frontend/notifier/models/all_router_response.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return MenuScreenState();
  }
}

class MenuScreenState extends ConsumerState<MenuScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var future;

  late final TreeNode<Records> tree;

  loadRouters() async {
    List<Records> routers = await ref.read(menuAuthProvider).getAll();
    tree = TreeNode.root();
    while (routers.isNotEmpty) {
      final i = routers.removeAt(0);
      if (i.parentId == 0) {
        tree.add(TreeNode(key: i.routerName, data: i));
      } else {
        addToTreenode(tree, i);
      }
    }
  }

  addToTreenode(TreeNode<Records> p, Records child) {
    // ignore: no_leading_underscores_for_local_identifiers
    for (final _p in p.childrenAsList) {
      if (((_p as TreeNode).data as Records).routerId == child.parentId) {
        _p.add(TreeNode(key: child.routerName, data: child));
      } else {
        addToTreenode(_p as TreeNode<Records>, child);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    future = loadRouters();
  }

  // ignore: unused_field
  late TreeViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Menu List",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: FutureBuilder(
                  future: future,
                  builder: (c, s) {
                    if (s.connectionState == ConnectionState.done) {
                      return TreeView.simple(
                          onTreeReady: (controller) {
                            _controller = controller;
                            controller.expandAllChildren(tree);
                          },
                          expansionIndicatorBuilder: (context, node) =>
                              ChevronIndicator.rightDown(
                                tree: node,
                                color: Colors.blue[700],
                                padding:
                                    const EdgeInsets.only(top: 22, right: 22),
                              ),

                          /// will throw `combinePaths not implemented in HTML renderer`
                          ///
                          /// exception on web with `--web-renderer html` if `IndentStyle`
                          ///
                          /// is not `none`
                          indentation: Indentation(
                              style: PlatformUtils.isDesktop
                                  ? IndentStyle.roundJoint
                                  : IndentStyle.none),
                          onItemTap: (item) {},
                          showRootNode: false,
                          builder: (ctx, node) {
                            String sub = "";
                            if (node.children.isNotEmpty) {
                              sub = "( has ${node.children.length} sub menus)";
                            }
                            return Card(
                              child: ListTile(
                                leading: SidebarIcons.getByRouter(
                                    (node.data as Records).router!),
                                title: Text((node.data as Records)
                                    .routerName
                                    .toString()),
                                subtitle: Text(
                                    (node.data as Records).router.toString() +
                                        sub),
                              ),
                            );
                          },
                          tree: tree);
                    }
                    return Container();
                  }))
        ],
      ),
    );
  }
}
