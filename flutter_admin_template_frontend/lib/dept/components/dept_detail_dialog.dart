import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/dept/models/single_dept_response.dart';
import 'package:flutter_admin_template_frontend/notifier/app_color_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DeptDetailDialog extends ConsumerWidget {
  const DeptDetailDialog({super.key, required this.response});
  final SingleDepartmentResponse response;

  static const TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: 550,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "部门详情",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Expanded(child: SizedBox()),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _titleWrapper(const Text(
                "部门编号",
                style: titleStyle,
              )),
              _contentWrapper(Text(response.deptId.toString())),
              _titleWrapper(const Text(
                "部门名称",
                style: titleStyle,
              )),
              _contentWrapper(Text(response.deptName.toString())),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _titleWrapper(const Text(
                "序号",
                style: titleStyle,
              )),
              _contentWrapper(Text(response.orderNumber.toString())),
              _titleWrapper(const Text(
                "创建时间",
                style: titleStyle,
              )),
              _contentWrapper(Text(DateFormat("yyyy-MM-dd HH:mm:ss").format(
                  DateTime.parse(response.createTime.toString()).toLocal()))),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleWrapper(const Text(
                "父级部门名",
                style: titleStyle,
              )),
              _contentWrapper(Text(response.parentDeptName.toString())),
              _titleWrapper(const Text(
                "备注",
                style: titleStyle,
              )),
              _contentWrapper(Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: ref.read(colorNotifier).currentColorTheme.$3),
                child: Text(response.remark.toString()),
              ))
            ],
          )
        ],
      ),
    );
  }

  Widget _titleWrapper(Widget child) {
    return SizedBox(
      height: 60,
      width: 100,
      child: child,
    );
  }

  Widget _contentWrapper(Widget child) {
    return SizedBox(
      height: 60,
      width: 150,
      child: child,
    );
  }
}
