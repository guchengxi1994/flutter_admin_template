import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/notifier/app_color_notifier.dart';
import 'package:flutter_admin_template_frontend/signin/components/components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              // AppStyle.loginBackgroundColor1,
              // AppStyle.loginBackgroundColor2
              ref.watch(colorNotifier).currentColorTheme.$1,
              ref.watch(colorNotifier).currentColorTheme.$2
            ])),
        child: Center(
          child: Container(
            width: 0.6 * MediaQuery.of(context).size.width,
            height: 0.6 * MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white),
            child: Row(
              children: [
                if (width > 900) const Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: LoginForm(),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
