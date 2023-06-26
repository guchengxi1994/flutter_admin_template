import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/log/notifier/log_summary_notifier.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/sign_in_summary_pie_chart.dart';

class LogSummaryScreen extends ConsumerWidget {
  LogSummaryScreen({super.key});

  final logSummaryProvider =
      ChangeNotifierProvider((ref) => LogSummaryNotifier()..init());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (MediaQuery.of(context).size.width > 900) {
      return LayoutGrid(
        areas: """
      table1 table2 table3
      logs   logs   logs
      """,
        columnSizes: [1.fr, 1.fr, 1.fr],
        rowSizes: [
          300.px,
          1.fr,
        ],
        columnGap: 3,
        rowGap: 3,
        children: [
          SignInSummaryPieChart(
            signIn: ref.watch(logSummaryProvider).signIns,
          ).inGridArea("table1"),
          Container().inGridArea("table2"),
          Container().inGridArea("table3"),
          Container().inGridArea("logs"),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 300,
            child: Center(
              child: SignInSummaryPieChart(
                signIn: ref.watch(logSummaryProvider).signIns,
              ),
            ),
          )
        ],
      );
    }
  }
}
