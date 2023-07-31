// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_init_to_null

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/common/screen_fit_utils.dart';
import 'package:flutter_admin_template_frontend/layout/notifier/sidebar_notifier.dart';
import 'package:flutter_admin_template_frontend/log/models/sign_in_response.dart';
import 'package:flutter_admin_template_frontend/log/notifier/sign_in_log_notifier.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_admin_template_frontend/table/components/search_condition.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../table/components/datatable_indicator.dart';
import './i18n/sign_in_log_screen.i18n.dart';

final signinLogNotifier =
    ChangeNotifierProvider<SignInLogNotifier>((ref) => SignInLogNotifier());

class SignInLogScreen extends ConsumerStatefulWidget {
  const SignInLogScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return SignInLogScreenState();
  }
}

class SignInLogScreenState extends ConsumerState<SignInLogScreen> {
  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();

  late double w1 = 50;
  late double w2 = 50;
  late double w3 = 100;
  late double w4 = 100;
  late double w5 = 75;
  late double w6 = 175;

  final GlobalKey<DatatableIndicatorState> globalKey = GlobalKey();

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(signinLogNotifier).init("", "get");
    });
  }

  final total = 550;

  late DateTime? _first = null;
  late DateTime? _last = null;
  late String? _status = null;
  late String? _keyword = null;

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
    w2 = (50 / total * realExtra).loose().fixMinSize(50);
    w3 = (100 / total * realExtra).loose().fixMinSize(100);
    w4 = (100 / total * realExtra).loose().fixMinSize(100);
    w5 = (75 / total * realExtra).loose().fixMinSize(75);
    w6 = (175 / total * realExtra).loose().fixMinSize(175);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        const SizedBox(
          height: 20,
        ),
        OperationSearchArea(
          inputHintText: "输入用户名".i18n,
          statuses: const ["success", "others"],
          onResetButtonClicked: () async {
            _first = null;
            _last = null;
            _status = null;
            _keyword = null;
            // await recordController.onReset();
            await ref.read(signinLogNotifier).onReset("", "");
            if (globalKey.currentState != null) {
              globalKey.currentState!.reset();
            }
          },
          onSubmitButtonClicked: (DateTime? first, DateTime? last,
              String? status, String? keyword, bool isDateSelected) async {
            if (globalKey.currentState != null) {
              globalKey.currentState!.reset();
            }
            if (isDateSelected) {
              _first = first;
              _last = last;
            }

            _status = status;
            _keyword = keyword;
            await ref
                .read(signinLogNotifier)
                .onSubmit("", _first, _last, _status, _keyword, isDateSelected);
          },
        ),
        const SizedBox(
          height: 20,
        ),
        _buildContent(),
        const SizedBox(
          height: 15,
        ),
        ref.watch(signinLogNotifier).pageLength == 0
            ? const SizedBox()
            : Center(
                child: DatatableIndicator(
                  key: globalKey,
                  pageLength: ref.watch(signinLogNotifier).pageLength,
                  whenIndexChanged: (int index) async {
                    debugPrint("[flutter] current index : $index");

                    await ref.read(signinLogNotifier).onPageIndexChange(
                        index, "", parameters: {
                      "startTime": _first,
                      "endTime": _last,
                      "state": _status,
                      "username": _keyword
                    });
                  },
                ),
              ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 15),
      child: Text(
        "登录记录".i18n,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildContent() {
    final records = ref.watch(signinLogNotifier).records;
    return records.isEmpty
        ? Expanded(
            child: Center(
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
                Text(
                  "没有记录".i18n,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 159, 159, 159), fontSize: 14),
                )
              ],
            )),
          ))
        : Expanded(
            child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: DataTable2(
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
                    "记录编号".i18n,
                    style: AppStyle.tableColumnStyle,
                  ),
                )),
                DataColumn(
                  label: SizedBox(
                    width: w2,
                    child: Text(
                      "用户编号".i18n,
                      style: AppStyle.tableColumnStyle,
                    ),
                  ),
                ),
                DataColumn(
                    label: SizedBox(
                  width: w3,
                  child: Text(
                    "用户名".i18n,
                    style: AppStyle.tableColumnStyle,
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: w4,
                  child: Text(
                    "登录IP".i18n,
                    style: AppStyle.tableColumnStyle,
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: w5,
                  child: Text(
                    "登录状态".i18n,
                    style: AppStyle.tableColumnStyle,
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: w6,
                  child: Text(
                    "登录时间".i18n,
                    style: AppStyle.tableColumnStyle,
                  ),
                )),
              ],
            ),
          ));
  }

  DataRow _buildRow(Records records) {
    return DataRow(cells: [
      DataCell(SizedBox(
        width: w1,
        child: Text(
          records.loginId.toString(),
          style: AppStyle.itemStyle,
        ),
      )),
      DataCell(SizedBox(
        width: w2,
        child: Text(
          records.userId.toString(),
          style: AppStyle.itemStyle,
        ),
      )),
      DataCell(SizedBox(
        width: w3,
        child: Text(
          records.userName.toString(),
          style: AppStyle.itemStyle,
        ),
      )),
      DataCell(SizedBox(
        width: w4,
        child: Text(
          records.loginIp.toString(),
          style: AppStyle.itemStyle,
        ),
      )),
      DataCell(SizedBox(
        width: w5,
        child: Text(
          records.loginState.toString(),
          style: AppStyle.itemStyle,
        ),
      )),
      DataCell(SizedBox(
        width: w6,
        child: Text(
          DateFormat("yyyy-MM-dd HH:mm:ss")
              .format(DateTime.parse(records.loginTime.toString()).toLocal()),
          style: AppStyle.itemStyle,
        ),
      )),
    ]);
  }
}
