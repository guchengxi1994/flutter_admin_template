import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class SmartDialogUtils {
  static warning(String message, {int duration = 2}) {
    SmartDialog.showToast(
      message,
      displayTime: Duration(seconds: duration),
      builder: (context) {
        return CustomToast(
          msg: message,
          color: const Color.fromARGB(255, 244, 153, 65),
          textColor: Colors.white,
          icon: const Icon(
            Icons.warning,
            color: Colors.white,
          ),
        );
      },
    );
  }

  static error(String message, {int duration = 2}) {
    SmartDialog.showToast(
      message,
      displayTime: Duration(seconds: duration),
      builder: (context) {
        return CustomToast(
            msg: message,
            color: const Color.fromARGB(255, 238, 97, 111),
            textColor: Colors.white,
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(3),
                color: Colors.white,
                child: const Icon(
                  Icons.clear_rounded,
                  size: 16,
                  color: Color.fromARGB(255, 238, 97, 111),
                ),
              ),
            ));
      },
    );
  }

  static ok(String message, {int duration = 2}) {
    SmartDialog.showToast(
      message,
      displayTime: Duration(seconds: duration),
      builder: (context) {
        return CustomToast(
            msg: message,
            color: const Color.fromARGB(255, 91, 203, 167),
            textColor: Colors.white,
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(3),
                color: Colors.white,
                child: const Icon(
                  Icons.clear_rounded,
                  size: 16,
                  color: Color.fromARGB(255, 91, 203, 167),
                ),
              ),
            ));
      },
    );
  }

  static message(String message, {int duration = 2}) {
    SmartDialog.showToast(
      message,
      displayTime: Duration(seconds: duration),
      builder: (context) {
        return CustomToast(
            msg: message,
            color: const Color.fromARGB(255, 40, 40, 255),
            textColor: Colors.white,
            icon: const Icon(
              Icons.error_sharp,
              color: Colors.white,
            ));
      },
    );
  }
}

class CustomToast extends StatelessWidget {
  const CustomToast(
      {Key? key,
      required this.msg,
      required this.color,
      required this.textColor,
      required this.icon})
      : super(key: key);

  final String msg;
  final Color color;
  final Color textColor;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: 250,
        height: 48,
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          //icon
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: icon,
          ),

          Expanded(
              child: Center(
            child: Text(msg, style: TextStyle(color: textColor)),
          )),
        ]),
      ),
    );
  }
}
