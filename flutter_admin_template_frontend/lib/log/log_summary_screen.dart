import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/extensions/size_extension.dart';
import 'package:flutter_admin_template_frontend/log/notifier/log_summary_notifier.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/sign_in_summary_pie_chart.dart';
import 'components/user_sign_in_bar_chart.dart';

class LogSummaryScreen extends ConsumerWidget {
  LogSummaryScreen({super.key});

  final logSummaryProvider =
      ChangeNotifierProvider((ref) => LogSummaryNotifier()..init());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (MediaQuery.of(context).size.getType() == WindowType.desktop) {
      return LayoutGrid(
        areas: """
      table1 table2 table3
      logs   logs   logs
      """,
        columnSizes: [1.fr, 1.fr, 1.fr],
        rowSizes: [
          330.px,
          1.fr,
        ],
        columnGap: 3,
        rowGap: 3,
        children: [
          SignInSummaryPieChart(
            signIn: ref.watch(logSummaryProvider).signIns,
          ).inGridArea("table1"),
          UserSigninBarChart(
            userSignIns: ref.watch(logSummaryProvider).userSignIns,
          ).inGridArea("table2"),
          Container().inGridArea("table3"),
          Container().inGridArea("logs"),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SignInSummaryPieChart(
              signIn: ref.watch(logSummaryProvider).signIns,
            ),
          ),
          SizedBox(
            width: 300,
            child: Center(
              child: UserSigninBarChart(
                userSignIns: ref.watch(logSummaryProvider).userSignIns,
              ),
            ),
          ),
        ],
      );
    }
  }
}
