import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/common/screen_fit_utils.dart';
import 'package:flutter_admin_template_frontend/notifier/app_color_notifier.dart';
import 'package:flutter_admin_template_frontend/notifier/global_notifier.dart';
import 'package:flutter_admin_template_frontend/routers.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../login_notifier.dart';
import 'logo.dart';

final loginProvider =
    ChangeNotifierProvider<LoginNotifier>((ref) => LoginNotifier());

// ignore: must_be_immutable
class LoginForm extends ConsumerWidget {
  LoginForm({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwardController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool passwordVisible = ref.watch(loginProvider).passwordVisible;

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
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: TextField(
                onChanged: (value) {
                  if (ref.read(loginProvider).isUsernameEmpty) {
                    ref.read(loginProvider).changeUsernameEmptyStatus(false);
                  }
                },
                style: const TextStyle(fontSize: 16),
                controller: usernameController,
                maxLength: 11,
                decoration: const InputDecoration(
                  hintText: "请输入账号名",
                  border: InputBorder.none,
                  counterText: "",
                ),
              ))
            ],
          ),
        ),
        Visibility(
            visible: ref.watch(loginProvider).isUsernameEmpty,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "用户名为空",
                style: TextStyle(color: Colors.red),
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
                    onSubmitted: (value) async {
                      final r = await ref.read(loginProvider).login(
                          usernameController.text, passwardController.text);
                      if (r) {
                        await ref.read(apiAuthProvider).init();
                        await ref.read(menuAuthProvider).refresh();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            FatRouters.dashboardScreen, (_) => false);
                      }
                    },
                    onChanged: (value) {
                      if (ref.read(loginProvider).isPasswordEmpty) {
                        ref
                            .read(loginProvider)
                            .changePasswordEmptyStatus(false);
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
                          ref.read(loginProvider).changePasswordStatus();
                        },
                      ),
                    )),
              )
            ],
          ),
        ),
        Visibility(
            visible: ref.watch(loginProvider).isPasswordEmpty,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "密码为空",
                style: TextStyle(color: Colors.red),
              ),
            )),
        SizedBox(
          height: 28.h(MediaQuery.of(context).size.height),
        ),
        InkWell(
          onTap: () async {
            if (usernameController.text == "") {
              ref.read(loginProvider).changeUsernameEmptyStatus(true);
            }

            if (passwardController.text == "") {
              ref.read(loginProvider).changePasswordEmptyStatus(true);
            }

            if (usernameController.text == "" ||
                passwardController.text == "") {
              return;
            }

            final r = await ref
                .read(loginProvider)
                .login(usernameController.text, passwardController.text);
            if (r) {
              await ref.read(apiAuthProvider).init();
              await ref.read(menuAuthProvider).refresh();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamedAndRemoveUntil(
                  FatRouters.dashboardScreen, (v) => false);
            }
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(122)),
                // color: Color.fromARGB(255, 40, 40, 255),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    // Color.fromARGB(255, 72, 78, 238),
                    // Color.fromARGB(255, 62, 154, 208),
                    ref.watch(colorNotifier).currentColorTheme.$1,
                    ref.watch(colorNotifier).currentColorTheme.$3,
                  ],
                ),
              ),
              // width: AppStyle.loginFormWidth,
              height: 40,
              child: Center(
                child: ref.watch(loginProvider).isLoading
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
