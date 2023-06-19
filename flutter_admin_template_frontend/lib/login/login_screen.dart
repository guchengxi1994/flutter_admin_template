import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/login/components/components.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              AppStyle.loginBackgroundColor1,
              AppStyle.loginBackgroundColor2
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
