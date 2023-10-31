// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'components/dept_tree.dart';
import 'dept_notifier.dart';

class DeptScreen extends ConsumerStatefulWidget {
  const DeptScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DeptScreenState();
  }
}

class DeptScreenState extends ConsumerState<DeptScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    scrollController.dispose();
    searchStringController.dispose();
    super.dispose();
  }

  loadTree() async {
    debugPrint("[flutter] dept repaint here");
    await ref.read(deptProvider).init();
  }

  final ScrollController scrollController = ScrollController();

  final searchStringController = TextEditingController();

  static const double indent = 30;
  static const double nameWidth = 500;
  static const double orderNum = 100;
  static const double time = 300;
  static const double operation = 300;
  static const double extraOperation = 50;
  late double total = nameWidth + orderNum + time + operation + extraOperation;
  late double screenWidth = total;

  Widget _search() {
    return Container(
      padding: const EdgeInsets.all(5),
      width: 180,
      height: 30,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(19)),
          border: Border.all(color: const Color.fromARGB(255, 232, 232, 232))),
      child: TextField(
        controller: searchStringController,
        onChanged: (value) {},
        style: const TextStyle(
            color: Color.fromARGB(255, 159, 159, 159), fontSize: 12),
        decoration: const InputDecoration(
          hintStyle: TextStyle(
              color: Color.fromARGB(255, 159, 159, 159), fontSize: 12),
          contentPadding: EdgeInsets.only(left: 10, bottom: 15),
          hintText: "输入部门名称",
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RawScrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: screenWidth > total ? screenWidth : total + 20,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _search(),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {}, child: const Text("检索"))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Expanded(child: DeptTree())
                ],
              ),
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
