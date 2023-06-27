import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/log/models/log_summary_response.dart';
import 'package:flutter_admin_template_frontend/styles/bar_chart_style.dart';

class UserSigninBarChart extends StatelessWidget {
  const UserSigninBarChart({super.key, required this.userSignIns});
  final List<UserSignIn> userSignIns;

  @override
  Widget build(BuildContext context) {
    if (userSignIns.isEmpty) {
      return Center(
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
    if (userSignIns.length == 1) {
      return Center(
        child: Text(
          "${userSignIns[0].userName} : ${userSignIns[0].count} 次",
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 300,
          child: DChartBar(
            barColor: (barData, index, id) =>
                BarChartStyle.getIndex(index! + 1),
            data: [
              {
                'id': 'User Sign In',
                'data': userSignIns
                    .map((e) => {'domain': e.userName, 'measure': e.count})
                    .toList()
              }
            ],
            domainLabelPaddingToAxisLine: 16,
            axisLineTick: 2,
            axisLinePointTick: 2,
            axisLinePointWidth: 10,
            axisLineColor: Colors.green,
            measureLabelPaddingToAxisLine: 16,
            barValue: (barData, index) => '${barData['measure']}',
            barValuePosition: BarValuePosition.auto,
            showBarValue: true,
          ),
        ),
        const Text("Fig.用户登录次数")
      ],
    );
  }
}
