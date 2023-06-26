import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/extensions/datetime_extension.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class RangeDatesSelector extends StatefulWidget {
  const RangeDatesSelector({Key? key, this.onTimeSelected}) : super(key: key);
  final VoidCallback? onTimeSelected;

  @override
  State<RangeDatesSelector> createState() => RangeDatesSelectorState();
}

class RangeDatesSelectorState extends State<RangeDatesSelector> {
  late DateTime firstDate = DateTime.now();
  late DateTime secondDate = DateTime.now();

  bool isDateSelected = false;

  void setSelected(bool b) {
    setState(() {
      isDateSelected = b;
      if (b == false) {
        firstDate = DateTime.now();
        secondDate = DateTime.now();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: JustTheTooltip(
          offset: -15,
          tailBuilder: (point1, point2, point3) {
            return Path()
              ..moveTo(point1.dx, point1.dy)
              ..lineTo(point3.dx, point3.dy)
              ..close();
          },
          isModal: true,
          content: SizedBox(
            width: 350,
            height: 300,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.range,
              ),
              onValueChanged: (value) {
                // // print(value.length);
                if (value.length == 2) {
                  if (value[0]!.isBefore(value[1]!)) {
                    setState(() {
                      isDateSelected = true;
                      firstDate = value[0]!;
                      secondDate = value[1]!;
                    });
                  } else {
                    setState(() {
                      isDateSelected = true;
                      firstDate = value[1]!;
                      secondDate = value[2]!;
                    });
                  }

                  if (widget.onTimeSelected != null) {
                    widget.onTimeSelected!.call();
                  }
                }
              },
              initialValue: [firstDate, secondDate],
            ),
          ),
          child: SizedBox(
            width: 300,
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _dateWrapper(firstDate.toChinese()),
                const Text(
                  "至",
                  style: TextStyle(
                      color: Color.fromARGB(255, 159, 159, 159), fontSize: 12),
                ),
                _dateWrapper(secondDate.toChinese())
              ],
            ),
          )),
    );
  }

  Widget _dateWrapper(String date) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: 120,
      height: 30,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(19)),
          border: Border.all(color: const Color.fromARGB(255, 232, 232, 232))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 13,
            height: 13,
            child: Icon(
              Icons.calendar_month_outlined,
              color: Color.fromARGB(255, 159, 159, 159),
              size: 13,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            // color: Colors.red,
            height: 30,
            // margin: EdgeInsets.only(bottom: 5),
            child: Center(
              child: Text(
                date,
                style: const TextStyle(
                    color: Color.fromARGB(255, 159, 159, 159), fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
