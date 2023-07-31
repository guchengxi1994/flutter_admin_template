import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/common/screen_fit_utils.dart';
import 'package:flutter_admin_template_frontend/layout/notifier/sidebar_notifier.dart';
import 'package:flutter_admin_template_frontend/role/models/role_list_response.dart'
    as role_list;
import 'package:flutter_admin_template_frontend/role/role_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../styles/app_style.dart';
import 'components/modify_role_dialog.dart';

final roleProvider =
    ChangeNotifierProvider<RoleNotifier>((ref) => RoleNotifier());

class RoleScreen extends ConsumerStatefulWidget {
  const RoleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return RoleScreenState();
  }
}

class RoleScreenState extends ConsumerState<RoleScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(roleProvider).init("", "get");
  }

  @override
  Widget build(BuildContext context) {
    final isCollapse = ref.watch(sidebarProvider).isCollapse;

    double realExtra;
    if (!isCollapse) {
      realExtra = MediaQuery.of(context).size.width - AppStyle.sidebarWidth;
    } else {
      realExtra = MediaQuery.of(context).size.width -
          AppStyle.sidebarCollapseWidth -
          /*padding*/ 10;
    }

    w1 = (50 / total * realExtra).loose().fixMinSize(50);
    w2 = (75 / total * realExtra).loose().fixMinSize(75);
    w3 = (100 / total * realExtra).loose().fixMinSize(100);
    w4 = (100 / total * realExtra).loose().fixMinSize(100);
    w5 = (150 / total * realExtra).loose().fixMinSize(150);
    w6 = (150 / total * realExtra).loose().fixMinSize(150);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Role List",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Expanded(child: _buildContent())
        ],
      ),
    );
  }

  late double w1 = 50;
  late double w2 = 75;
  late double w3 = 100;
  late double w4 = 100;
  late double w5 = 150;
  late double w6 = 150;

  final total = 625;

  Widget _buildContent() {
    final records = ref.watch(roleProvider).records;
    return records.isNotEmpty
        ? DataTable2(
            columnSpacing: 0,
            showBottomBorder: true,
            horizontalMargin: 0,
            dividerThickness: 1,
            rows: records.map((e) => _buildRow(e)).toList(),
            columns: [
              DataColumn(
                  label: SizedBox(
                width: w1,
                child: Text(
                  "角色编号",
                  style: AppStyle.tableColumnStyle,
                ),
              )),
              DataColumn(
                label: SizedBox(
                  width: w2,
                  child: Text(
                    "名称",
                    style: AppStyle.tableColumnStyle,
                  ),
                ),
              ),
              DataColumn(
                  label: SizedBox(
                width: w3,
                child: Text(
                  "创建时间",
                  style: AppStyle.tableColumnStyle,
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: w4,
                child: Text(
                  "修改时间",
                  style: AppStyle.tableColumnStyle,
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: w5,
                child: Text(
                  "备注",
                  style: AppStyle.tableColumnStyle,
                ),
              )),
              DataColumn(
                  label: SizedBox(
                width: w6,
                child: Text(
                  "操作",
                  style: AppStyle.tableColumnStyle,
                ),
              )),
            ],
          )
        : Center(
            child: SizedBox(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/operation.png",
                  width: 126,
                  height: 107,
                ),
                const Text(
                  "没有记录",
                  style: TextStyle(
                      color: Color.fromARGB(255, 159, 159, 159), fontSize: 14),
                )
              ],
            )),
          );
  }

  DataRow _buildRow(role_list.Records e) {
    return DataRow(cells: [
      DataCell(SizedBox(
        child: Text(
          e.roleId.toString(),
          style: AppStyle.itemStyle,
        ),
      )),
      DataCell(SizedBox(
        child: Text(
          e.roleName.toString(),
          style: AppStyle.itemStyle,
        ),
      )),
      DataCell(SizedBox(
        child: Text(
          DateFormat("yyyy-MM-dd HH:mm:ss")
              .format(DateTime.parse(e.createTime.toString()).toLocal()),
          style: AppStyle.itemStyle,
        ),
      )),
      DataCell(SizedBox(
        child: Text(
          DateFormat("yyyy-MM-dd HH:mm:ss")
              .format(DateTime.parse(e.updateTime.toString()).toLocal()),
          style: AppStyle.itemStyle,
        ),
      )),
      DataCell(SizedBox(
        child: Text(
          e.remark.toString(),
          style: AppStyle.itemStyle,
        ),
      )),
      DataCell(SizedBox(
        child: Row(children: [
          InkWell(
            onTap: () {},
            child: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          InkWell(
            onTap: () {
              showGeneralDialog(
                  context: context,
                  pageBuilder: (ctx, a, b) {
                    return Center(
                      child: ModifyRoleDialog(
                        roleId: e.roleId!,
                      ),
                    );
                  });
            },
            child: const Icon(
              Icons.change_circle,
              color: Colors.blue,
            ),
          )
        ]),
      )),
    ]);
  }
}
