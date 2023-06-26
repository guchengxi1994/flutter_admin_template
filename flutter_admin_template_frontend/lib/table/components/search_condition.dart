// ignore_for_file: avoid_init_to_null

import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/styles/app_style.dart';

import 'custom_dropdown_button.dart';
import 'range_dates_selector.dart';

typedef OnSubmitButtonClicked = dynamic Function(DateTime? first,
    DateTime? last, String? status, String? keyword, bool isDateSelected);
typedef OnResetButtonClicked = dynamic Function();

class OperationSearchArea extends StatefulWidget {
  const OperationSearchArea(
      {Key? key,
      required this.onSubmitButtonClicked,
      required this.statuses,
      this.extraButtons = const [],
      this.extraWidth = 0,
      this.onResetButtonClicked,
      this.needStatus = true,
      this.hintText = "选择状态",
      this.inputHintText = "请输入关键字"})
      : assert((extraWidth == 0 && extraButtons.length == 0) ||
            (extraWidth > 0 && extraButtons.length > 0)),
        super(key: key);
  final OnSubmitButtonClicked onSubmitButtonClicked;
  final List<String> statuses;
  final List<Widget> extraButtons;
  final double extraWidth;
  final OnResetButtonClicked? onResetButtonClicked;
  final bool needStatus;
  final String hintText;
  final String inputHintText;

  @override
  State<OperationSearchArea> createState() => OperationSearchAreaState();
}

class OperationSearchAreaState extends State<OperationSearchArea> {
  late bool searchEnabled = false;
  late bool resetEnable = false;

  @override
  Widget build(BuildContext context) {
    late double restWidth = MediaQuery.of(context).size.width -
        AppStyle.sidebarWidth -
        300 -
        150 -
        180 -
        88 * 2 -
        200 -
        widget.extraWidth;
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: [
        RangeDatesSelector(
          key: datePickerKey,
          onTimeSelected: () {
            setState(() {
              searchEnabled = true;
            });
          },
        ),
        Visibility(visible: widget.needStatus, child: _statusSelection()),
        _search(),
        _searchButton(),
        _resetButton(),
        if (restWidth > 0)
          SizedBox(
            width: restWidth,
          ),
        ...widget.extraButtons
        // Expanded(child: Container()),
      ],
    );
  }

  final GlobalKey<RangeDatesSelectorState> datePickerKey = GlobalKey();

  String? selectedStatus = null;

  Widget _statusSelection() {
    return MyCustomDropdownButton(
        style: const TextStyle(
            color: Color.fromARGB(255, 159, 159, 159), fontSize: 10),
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 159, 159, 159), fontSize: 12),
        icon: const Icon(Icons.arrow_drop_down,
            color: Color.fromARGB(255, 232, 232, 232)),
        buttonHeight: 30,
        buttonDecoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(19)),
            border:
                Border.all(color: const Color.fromARGB(255, 232, 232, 232))),
        hint: widget.hintText,
        value: selectedStatus,
        dropdownItems: widget.statuses,
        onChanged: (v) {
          setState(() {
            selectedStatus = v;
            searchEnabled = true;
          });
        });
  }

  final TextEditingController searchStringController = TextEditingController();

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
        onChanged: (value) {
          if (value != "") {
            if (!searchEnabled) {
              setState(() {
                searchEnabled = true;
              });
            }
          } else {
            if (selectedStatus == null &&
                datePickerKey.currentState!.isDateSelected == false) {
              setState(() {
                searchEnabled = false;
              });
            }
          }
        },
        style: const TextStyle(
            color: Color.fromARGB(255, 159, 159, 159), fontSize: 12),
        decoration: InputDecoration(
          hintStyle: const TextStyle(
              color: Color.fromARGB(255, 159, 159, 159), fontSize: 12),
          contentPadding: const EdgeInsets.only(left: 10, bottom: 15),
          hintText: widget.inputHintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchStringController.dispose();
    super.dispose();
  }

  final onActivateDecorate = const BoxDecoration(
    color: AppStyle.appBlue,
    borderRadius: BorderRadius.all(Radius.circular(19)),
  );

  final disabledDecorate = const BoxDecoration(
    color: Color.fromARGB(255, 218, 223, 229),
    borderRadius: BorderRadius.all(Radius.circular(19)),
  );

  Widget _searchButton() {
    return InkWell(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      mouseCursor:
          !searchEnabled ? SystemMouseCursors.noDrop : SystemMouseCursors.click,
      onTap: !searchEnabled
          ? null
          : () {
              var first = datePickerKey.currentState!.firstDate;
              var last = datePickerKey.currentState!.secondDate
                  .add(const Duration(hours: 23, minutes: 29, seconds: 59));

              widget.onSubmitButtonClicked(
                  first,
                  last,
                  selectedStatus,
                  searchStringController.text,
                  datePickerKey.currentState!.isDateSelected);

              setState(() {
                resetEnable = true;
              });
            },
      child: Container(
        width: 88,
        height: 30,
        decoration: searchEnabled ? onActivateDecorate : disabledDecorate,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/search2.png",
              width: 13,
              height: 13,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              "检索",
              style: TextStyle(color: Colors.white, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  Widget _resetButton() {
    return InkWell(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      mouseCursor:
          !resetEnable ? SystemMouseCursors.noDrop : SystemMouseCursors.click,
      onTap: !resetEnable
          ? null
          : () {
              setState(() {
                searchStringController.text = "";
                selectedStatus = null;
                datePickerKey.currentState!.setSelected(false);

                searchEnabled = false;
                resetEnable = false;
              });

              if (widget.onResetButtonClicked != null) {
                widget.onResetButtonClicked!.call();
              }
            },
      child: Container(
        width: 88,
        height: 30,
        decoration: resetEnable ? onActivateDecorate : disabledDecorate,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/reset.png",
              width: 13,
              height: 13,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              "重置",
              style: TextStyle(color: Colors.white, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
