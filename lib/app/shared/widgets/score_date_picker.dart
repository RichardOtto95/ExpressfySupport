import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../color_theme.dart';
import '../utilities.dart';

class ScoreDatePicker extends StatefulWidget {
  final void Function(DateTime?) onConfirm;
  final void Function() onCancel;

  const ScoreDatePicker({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  _ScoreDatePickerState createState() => _ScoreDatePickerState();
}

class _ScoreDatePickerState extends State<ScoreDatePicker> {
  CalendarController calendarController = CalendarController();
  DateTime today = DateTime.now();
  DateTime lastDate = DateTime.now();
  DateTime? _date;

  @override
  void initState() {
    calendarController.displayDate = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    calendarController.dispose();
    super.dispose();
  }

  List<String> letterDays = ["D", "S", "T", "Q", "Q", "S", "S"];

  List<String> weekDays = [
    "",
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sab",
    "Dom",
  ];

  @override
  Widget build(BuildContext context) {
    String month = DateFormat(
      "MMMM",
    ).format(calendarController.displayDate!);
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () {
              widget.onCancel();
            },
            child: Container(
              height: maxHeight(context),
              width: maxWidth(context),
              color: totalBlack.withOpacity(.5),
              alignment: Alignment.center,
            ),
          ),
          Container(
            height: wXD(448, context),
            width: wXD(339, context),
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Column(
              children: [
                Container(
                  width: wXD(339, context),
                  height: wXD(107, context),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                    color: primary,
                  ),
                  padding: EdgeInsets.only(
                      left: wXD(30, context), top: wXD(14, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        today.year.toString(),
                        textAlign: TextAlign.center,
                        style: textFamily(
                          fontSize: 17,
                          color: white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: wXD(7, context)),
                      Text(
                        weekDays[today.weekday] +
                            ", ${today.day} de " +
                            DateFormat("MMMM").format(today).substring(0, 3),
                        textAlign: TextAlign.center,
                        style: textFamily(
                          fontSize: 32,
                          color: white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                        width: wXD(280, context),
                        height: wXD(340, context),
                        padding: EdgeInsets.only(top: wXD(35, context)),
                        alignment: Alignment.center,
                        child: SfCalendar(
                          onViewChanged: (viewChangedDetails) {
                            print(
                                "${viewChangedDetails.visibleDates.first}   -   $today");
                            if (viewChangedDetails.visibleDates.first.month !=
                                    lastDate.month ||
                                viewChangedDetails.visibleDates.first.year !=
                                    lastDate.year) {
                              setState(() {});
                            }
                            lastDate = viewChangedDetails.visibleDates.first;
                          },
                          onTap: (calendarTapDetails) =>
                              _date = calendarTapDetails.date,
                          controller: calendarController,
                          view: CalendarView.month,
                          cellBorderColor: primary,
                          monthCellBuilder: (context, details) {
                            return Material(
                              borderRadius: BorderRadius.circular(500),
                              color: Colors.transparent,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  details.date.day.toString(),
                                  style: textFamily(
                                    color: primary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                          monthViewSettings: MonthViewSettings(
                            showTrailingAndLeadingDates: false,
                          ),
                          selectionDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: primary, width: 2),
                          ),
                        )
                        // CalendarDatePicker(
                        //   firstDate: DateTime(1900),
                        //   lastDate: DateTime(2200),
                        //   initialDate: DateTime.now(),
                        //   onDateChanged: (date) => _date = date,
                        // )

                        // SfDateRangePicker(
                        //   controller: datePickerController,
                        //   selectionMode: DateRangePickerSelectionMode.single,
                        //   onSelectionChanged: (args){},
                        //   cellBuilder: (context, cellDetails) {
                        //     return Material(
                        //       borderRadius: BorderRadius.circular(500),
                        //       color: Colors.transparent,
                        //       child: Container(
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           cellDetails.date.day.toString(),
                        //           style: textFamily(
                        //             color: primary,
                        //             fontSize: 17,
                        //             fontWeight: FontWeight.w400,
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                        ),
                    Container(
                      width: wXD(280, context),
                      height: wXD(95, context),
                      color: white,
                      padding: EdgeInsets.only(top: wXD(10, context)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => setState(
                                    () => calendarController.backward!()),
                                child: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: wXD(15, context),
                                  color: primary,
                                ),
                              ),
                              Text(
                                month.substring(0, 1).toUpperCase() +
                                    month.substring(1, month.length) +
                                    " de " +
                                    calendarController.displayDate!.year
                                        .toString(),
                                style: textFamily(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: primary,
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(
                                    () => calendarController.forward!()),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: wXD(15, context),
                                  color: primary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: List.generate(
                              7,
                              (index) => Expanded(
                                child: Text(
                                  letterDays[index],
                                  textAlign: TextAlign.center,
                                  style: textFamily(
                                    fontSize: 17,
                                    color: grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: wXD(6, context),
                      right: -12,
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: widget.onCancel,
                            child: Text(
                              "Cancelar",
                              textAlign: TextAlign.center,
                              style: textFamily(
                                fontSize: 17,
                                color: primary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(width: wXD(10, context)),
                          TextButton(
                            onPressed: () => widget.onConfirm(_date),
                            child: Text(
                              "Ok",
                              textAlign: TextAlign.center,
                              style: textFamily(
                                fontSize: 17,
                                color: primary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
