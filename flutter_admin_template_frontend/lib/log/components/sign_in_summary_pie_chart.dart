import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/log/models/log_summary_response.dart';
import 'package:flutter_admin_template_frontend/styles/pie_chart_style.dart';

class SignInSummaryPieChart extends StatelessWidget {
  const SignInSummaryPieChart({super.key, required this.signIn});
  final List<SignIn> signIn;

  @override
  Widget build(BuildContext context) {
    if (signIn.isEmpty) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 300,
          child: DChartPie(
            data: signIn
                .map((e) => {'domain': e.loginState, 'measure': e.count})
                .toList(),
            fillColor: (p, i) => PieChartStyle.getIndex(i! + 1),
            pieLabel: (pieData, index) {
              return "${pieData['domain']}: ${pieData['measure']} times";
            },
          ),
        ),
        const Text("Fig.登录状态")
      ],
    );
  }
}
