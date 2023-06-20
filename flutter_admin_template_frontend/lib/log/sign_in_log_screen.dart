import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/log/notifier/sign_in_log_notifier.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signinLogNotifier =
    ChangeNotifierProvider<SignInLogNotifier>((ref) => SignInLogNotifier());

// class SignInLogScreen extends ConsumerWidget {
//   const SignInLogScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final records = ref.watch(signinLogNotifier).records;
//     print(records.length);
//     return const Text("sign in");
//   }
// }

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

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(signinLogNotifier).records;
    return Text('${records.length}');
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
            padding: const EdgeInsets.only(left: 16),
            child: Scrollbar(
              controller: controller2,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: controller2,
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  controller: controller,
                  child: DataTable(
                    dividerThickness: 1,
                    rows: [],
                    columns: [
                      DataColumn(
                          label: SizedBox(
                        width: 50,
                        child: Text(
                          "Login Id",
                          style: AppStyle.tableColumnStyle,
                        ),
                      )),
                      DataColumn(
                        label: SizedBox(
                          width: 50,
                          child: Text(
                            "User Id",
                            style: AppStyle.tableColumnStyle,
                          ),
                        ),
                      ),
                      DataColumn(
                          label: SizedBox(
                        width: 50,
                        child: Text(
                          "Login IP",
                          style: AppStyle.tableColumnStyle,
                        ),
                      )),
                      DataColumn(
                          label: SizedBox(
                        width: 50,
                        child: Text(
                          "Login Time",
                          style: AppStyle.tableColumnStyle,
                        ),
                      )),
                      DataColumn(
                          label: SizedBox(
                        width: 50,
                        child: Text(
                          "Login Status",
                          style: AppStyle.tableColumnStyle,
                        ),
                      )),
                      DataColumn(
                          label: SizedBox(
                        width: 50,
                        child: Text(
                          "Username",
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
}
