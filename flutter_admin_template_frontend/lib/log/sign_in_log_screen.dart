import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/common/screen_fit_utils.dart';
import 'package:flutter_admin_template_frontend/layout/notifier/sidebar_notifier.dart';
import 'package:flutter_admin_template_frontend/log/models/sign_in_response.dart';
import 'package:flutter_admin_template_frontend/log/notifier/sign_in_log_notifier.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../table/components/datatable_indicator.dart';

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

  @override
  Widget build(BuildContext context) {
    final isCollapse = ref.watch(sidebarProvider).isCollapse;

    double realExtra;
    if (!isCollapse) {
      realExtra = MediaQuery.of(context).size.width - AppStyle.sidebarWidth;
    } else {
      realExtra =
          MediaQuery.of(context).size.width - AppStyle.sidebarCollapseWidth;
    }

    w1 = (50 / total * realExtra).loose().fixMinSize(50);
    w2 = (50 / total * realExtra).loose().fixMinSize(50);
    w3 = (100 / total * realExtra).loose().fixMinSize(100);
    w4 = (100 / total * realExtra).loose().fixMinSize(100);
    w5 = (75 / total * realExtra).loose().fixMinSize(75);
    w6 = (175 / total * realExtra).loose().fixMinSize(175);

    return Column(
      children: [
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

                    await ref
                        .read(signinLogNotifier)
                        .onPageIndexChange(index, "");
                    // // print(index);
                    // await recordController.onPageIndexChange(index,
                    //     first: _first,
                    //     last: _last,
                    //     status: _status,
                    //     keyword: _keyword);
                  },
                ),
              ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _buildContent() {
    final records = ref.watch(signinLogNotifier).records;
    return records.isEmpty
        ? Expanded(
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
                "No Records",
                style: TextStyle(
                    color: Color.fromARGB(255, 159, 159, 159), fontSize: 14),
              )
            ],
          )))
        : Expanded(
            child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Scrollbar(
              controller: controller2,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: controller2,
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  controller: controller,
                  child: DataTable(
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
                          "Login Id",
                          style: AppStyle.tableColumnStyle,
                        ),
                      )),
                      DataColumn(
                        label: SizedBox(
                          width: w2,
                          child: Text(
                            "User Id",
                            style: AppStyle.tableColumnStyle,
                          ),
                        ),
                      ),
                      DataColumn(
                          label: SizedBox(
                        width: w3,
                        child: Text(
                          "Username",
                          style: AppStyle.tableColumnStyle,
                        ),
                      )),
                      DataColumn(
                          label: SizedBox(
                        width: w4,
                        child: Text(
                          "Login IP",
                          style: AppStyle.tableColumnStyle,
                        ),
                      )),
                      DataColumn(
                          label: SizedBox(
                        width: w5,
                        child: Text(
                          "Login Status",
                          style: AppStyle.tableColumnStyle,
                        ),
                      )),
                      DataColumn(
                          label: SizedBox(
                        width: w6,
                        child: Text(
                          "Login Time",
                          style: AppStyle.tableColumnStyle,
                        ),
                      )),
                    ],
                  ),
                ),
              ),
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
