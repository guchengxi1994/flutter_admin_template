// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_admin_template_frontend/notifier/app_color_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef QueryInitialData<T> = dynamic Function();
typedef QueryByIndex<T> = dynamic Function(int index);
typedef IndicatorBuilder = Widget Function(Widget child);

const double size = 30;

class DatatableIndicator extends ConsumerStatefulWidget {
  const DatatableIndicator(
      {Key? key,
      this.initialIndex = 1,
      required this.pageLength,
      this.countPerPage = 10,
      required this.whenIndexChanged,
      this.indicatorBuilder})
      : super(key: key);
  final int initialIndex;
  final int pageLength;
  final int countPerPage;
  final QueryByIndex whenIndexChanged;
  final IndicatorBuilder? indicatorBuilder;

  @override
  ConsumerState<DatatableIndicator> createState() => DatatableIndicatorState();
}

class DatatableIndicatorState extends ConsumerState<DatatableIndicator> {
  List _list = []; // 存放页码的数组
  late int _total = 0; // 页码数量（总数据量/一页需要展示多少条数据）
  late int _pageIndex = widget.initialIndex; // 当前页码

  void reset() {
    setState(() {
      _pageIndex = 1;
    });
  }

  /*
	      假如：
	        在一行上展示七个页码item，那么要对total进行分配，并且需要根据当前的页码来决定list里面页码的规划
	   */
  void managePage() {
    _list = []; // 将页码数组制空
    if (_total <= 1) {
      // 当页码数量小于等于1时就不需要页码了，直接跳过，此时list为空数组
      return;
    }
    if (_total <= 7) {
      // 7：是我自己规定一行内展示的页码item数量，需要展示多少可以自己定义，当小于等于7时，直接进行展示这7个页码item
      for (var i = 0; i < _total; i++) {
        _list.add(i + 1);
      }
    } else if (_pageIndex <= 4) {
      // 当页码大于7后，则需要根据当前页码对有些页码进行隐藏
      _list = [1, 2, 3, 4, 5, "...", _total];
    } else if (_pageIndex > _total - 3) {
      // 以此类推
      _list = [1, 2, "...", _total - 3, _total - 2, _total - 1, _total];
    } else {
      _list = [
        1,
        "...",
        _pageIndex - 1,
        _pageIndex,
        _pageIndex + 1,
        "...",
        _total
      ];
    }
    // 页码制定好后，根据自己需求，加上前一页按钮，后一页按钮
    _list.insert(0, "上一页");
    _list.add("下一页");
  }

  @override
  Widget build(BuildContext context) {
    _total = widget.pageLength;
    managePage();
    return Wrap(
      spacing: 5,
      children: _list.mapIndexed((index, ele) {
        if (index == 0) {
          return GestureDetector(
            onTap: () {
              if (_pageIndex > 1) {
                setState(() {
                  _pageIndex--;
                  // 改变页码在这里发送事件通知
                  widget.whenIndexChanged(_pageIndex);
                });
              }
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 230, 223, 223)),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    color: ele == _pageIndex
                        ? ref.watch(colorNotifier).currentColorTheme.$0
                        : Colors.white),
                child: const Icon(Icons.chevron_left),
              ),
            ),
          );
        }
        if (index == _list.length - 1) {
          return GestureDetector(
            onTap: () {
              if (_pageIndex < _total) {
                setState(() {
                  _pageIndex++;
                  // 改变页码在这里发送事件通知
                  widget.whenIndexChanged(_pageIndex);
                });
              }
            },
            // child: buildPagerItem(child: Text(ele.toString())),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 230, 223, 223)),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    color: ele == _pageIndex
                        ? ref.watch(colorNotifier).currentColorTheme.$0
                        : Colors.white),
                child: const Icon(Icons.chevron_right),
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            if (ele != "...") {
              setState(() {
                if (_pageIndex != ele) {
                  _pageIndex = ele;
                  // 改变页码在这里发送事件通知
                  widget.whenIndexChanged(_pageIndex);
                }
              });
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 230, 223, 223)),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  color: ele == _pageIndex
                      ? ref.watch(colorNotifier).currentColorTheme.$0
                      : Colors.white),
              child: Center(
                child: Text("$ele",
                    // 当前页码对应的组件的样式
                    style: ele == _pageIndex
                        ? const TextStyle(color: Colors.white)
                        : const TextStyle(color: Colors.black)),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
