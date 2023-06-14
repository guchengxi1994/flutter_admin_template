import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/common/screen_utils.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:provider/provider.dart';

import '../login_controller.dart';
import 'logo.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isPasswordEmpty = false;
  bool isUsernameEmpty = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool passwordVisible = context.watch<LoginController>().passwordVisible;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50.h(MediaQuery.of(context).size.height),
        ),
        const LogoWidget(),
        SizedBox(
          height: 35.h(MediaQuery.of(context).size.height),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppStyle.loginLightgrey1,
            borderRadius: const BorderRadius.all(Radius.circular(122)),
            // border: Border.all(
            //     color: const Color.fromARGB(255, 212, 203, 203),
            //     width: 0.5),
          ),
          // width: AppStyle.loginFormWidth,
          // height: AppStyle.loginFormHeight,
          child: Row(
            children: [
              // const Padding(
              //   padding: EdgeInsets.only(left: 10, right: 10),
              //   child: Icon(Icons.phone_iphone),
              // ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: TextField(
                onChanged: (value) {
                  if (isUsernameEmpty) {
                    setState(() {
                      isUsernameEmpty = false;
                    });
                  }
                },
                style: const TextStyle(fontSize: 16),
                controller: usernameController,
                maxLength: 11,
                decoration: const InputDecoration(
                  hintText: "请输入手机号码",
                  border: InputBorder.none,
                  counterText: "",
                ),
              ))
            ],
          ),
        ),
        Visibility(
            visible: isUsernameEmpty,
            child: Container(
              // width: AppStyle.loginFormWidth,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "用户名为空",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )),
        SizedBox(
          height: 20.h(MediaQuery.of(context).size.height),
        ),
        Container(
          // width: AppStyle.loginFormWidth,
          decoration: BoxDecoration(
            color: AppStyle.loginLightgrey1,
            borderRadius: const BorderRadius.all(Radius.circular(122)),
            // border: Border.all(
            //     color: const Color.fromARGB(255, 212, 203, 203),
            //     width: 0.5),
          ),
          child: Row(
            children: [
              // const Padding(
              //   padding: EdgeInsets.only(left: 10, right: 10),
              //   child: Icon(Icons.password),
              // ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                    onSubmitted: (value) async {},
                    onChanged: (value) {
                      if (isPasswordEmpty) {
                        setState(() {
                          isPasswordEmpty = false;
                        });
                      }
                    },
                    obscuringCharacter: "*",
                    style: const TextStyle(fontSize: 16),
                    controller: passwardController,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 14),
                      hintText: "请输入密码",
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          //根据passwordVisible状态显示不同的图标
                          passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          //更新状态控制密码显示或隐藏
                          context
                              .read<LoginController>()
                              .changePasswordStatus();
                        },
                      ),
                    )),
              )
            ],
          ),
        ),
        Visibility(
            visible: isPasswordEmpty,
            child: Container(
              width: 300,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "密码为空",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )),
        SizedBox(
          height: 28.h(MediaQuery.of(context).size.height),
        ),
        InkWell(
          onTap: () async {},
          child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(122)),
                // color: Color.fromARGB(255, 40, 40, 255),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromARGB(255, 72, 78, 238),
                    Color.fromARGB(255, 62, 154, 208),
                  ],
                ),
              ),
              // width: AppStyle.loginFormWidth,
              height: 40,
              child: Center(
                child: context.watch<LoginController>().isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "立即登录",
                        style: TextStyle(color: Colors.white),
                      ),
              )),
        )
      ],
    );
  }
}
