// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class SpreadWidget extends StatefulWidget {
  const SpreadWidget({Key? key}) : super(key: key);

  @override
  _SpreadWidgetState createState() => _SpreadWidgetState();
}

class _SpreadWidgetState extends State<SpreadWidget>
    with TickerProviderStateMixin {
  bool offstage = true;
  bool zhankai = false;

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween(begin: 0.0, end: 150.0).animate(controller)
      ..addListener(() {
        if (animation.status == AnimationStatus.dismissed &&
            animation.value == 0.0) {
          offstage = !offstage;
        }
        setState(() => {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 100,
      child: Stack(
        children: [
          const Positioned(
              top: 10,
              left: 20,
              child: Text(
                "展开/收起",
                style: TextStyle(fontSize: 20),
              )),
          Positioned(
            top: 50,
            left: ((animation.value) > 150 ? 150 : animation.value),
            child: Offstage(
              offstage: offstage,
              child: Container(
                color: Colors.yellow,
                width: 50,
                height: 50,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: ((animation.value) > 100 ? 100 : animation.value),
            child: Offstage(
              offstage: offstage,
              child: Container(
                color: Colors.red,
                width: 50,
                height: 50,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: ((animation.value) > 50 ? 50 : animation.value),
            child: Offstage(
              offstage: offstage,
              child: Container(
                color: Colors.yellow,
                width: 50,
                height: 50,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  zhankai = !zhankai;
                  if (!zhankai) {
                    //展开
                    offstage = !offstage;
                    //启动动画(正向执行)
                    controller.forward();
                  } else {
                    controller.reverse();
                  }
                });
              },
              child: Container(
                width: 50,
                height: 50,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

void main() {
  runApp(const MaterialApp(
    home: Material(
      child: SpreadWidget(),
    ),
  ));
}
