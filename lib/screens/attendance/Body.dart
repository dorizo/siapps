import 'package:classes_app/models/AttendanceModel.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:classes_app/models/CalendarModel.dart';
import 'package:intl/intl.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Body extends StatelessWidget {
  Body(
      {Key key,
      @required this.totalAttended,
      @required this.totalMissed,
      @required this.totalUnspecified,
      @required this.selectedMonth,
      @required this.selectedYear,
      @required this.selectedClasses,
      @required this.monthList,
      @required this.yearList,
      @required this.classList,
      @required this.calendarTopDays,
      @required this.calendarModelList,
      @required this.attendanceModelList,
      @required this.onMonthSelected,
      @required this.onYearSelected,
      @required this.onClassesSelected,
      @required this.onDateSelected})
      : super(key: key);

  static DateTime now = new DateTime.now();

  int selectedMonth;
  String selectedYear;
  String selectedClasses;

  String totalAttended = "0";
  String totalMissed = "0";
  String totalUnspecified = "0";

  List<String> monthList;
  List<String> yearList;
  List<String> classList;

  List<CalendarModel> calendarModelList;
  List<String> calendarTopDays;
  List<AttendanceModel> attendanceModelList;

  final Function(int) onMonthSelected;
  final Function(String) onYearSelected;
  final Function(String) onClassesSelected;
  final Function(CalendarModel, AttendanceModel) onDateSelected;

  @override
  Widget build(BuildContext context) {
    final int currentMonth = (now.month);
    final int currentDay = (now.day);

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 250) / 2;
    final double itemWidth = size.width / 2;

    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
              child: new Row(
                children: <Widget>[
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        AppLocalizations.of(context).translate("month"),
                        style: TextStyle(
                          color: ColorsInt.colorText,
                          fontFamily: 'regular',
                        ),
                      ),
                      DropdownButton<String>(
                        value: new DateFormat('MMMM')
                            .format(new DateTime(now.year, selectedMonth, 1)),
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: ColorsInt.colorText),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: (String newValue) {
                          onMonthSelected(monthList.indexOf(newValue) + 1);
                        },
                        items: monthList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "regular",
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  new Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          AppLocalizations.of(context).translate("year"),
                          style: TextStyle(
                            color: ColorsInt.colorText,
                            fontFamily: 'regular',
                          ),
                        ),
                        DropdownButton<String>(
                          value: new DateFormat('yyyy')
                              .format(new DateTime(int.parse(selectedYear), 1)),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: ColorsInt.colorText),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          onChanged: (String newValue) =>
                              onYearSelected(newValue),
                          items: yearList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "regular",
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          AppLocalizations.of(context).translate("classes"),
                          style: TextStyle(
                            color: ColorsInt.colorText,
                            fontFamily: 'regular',
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedClasses,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: ColorsInt.colorText),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          onChanged: (String newValue) =>
                              onClassesSelected(newValue),
                          items: classList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "regular",
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              width: double.infinity,
              color: ColorsInt.colorPrimary,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: new Row(
                children: _getTopDays(),
              ),
            ),
            new OrientationBuilder(builder: (context, orientation) {
              var isPortrait =
                  MediaQuery.of(context).orientation == Orientation.portrait;
              return new GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: (isPortrait)
                        ? (MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 2))
                        : 1,
                  ),
                  itemCount: calendarModelList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, position) {
                    var calendarModel = calendarModelList[position];

                    var colorBox = Colors.transparent;
                    var colorText = ColorsInt.colorText;
                    var isToday = false;
                    var isAttended = false;
                    var isAbcent = false;
                    var isLeav = false;
                    if (int.parse(selectedYear) == now.year &&
                        selectedMonth == currentMonth) {
                      if (calendarModel.day == currentDay) {
                        isToday = true;
                      }
                    }
                    var attendanceModel = _getAttendanceDetailByDate(
                        "${calendarModel.year}-${NumberFormat("00").format(calendarModel.month)}-${NumberFormat("00").format(calendarModel.day)}");
                    if (attendanceModel != null) {
                      isAttended = (attendanceModel.attended == "attended");
                      isAbcent = (attendanceModel.attended == "absent");
                      isLeav = (attendanceModel.attended == "leave");
                    }

                    if (isAttended) {
                      colorBox = ColorsInt.colorAttended;
                      colorText = ColorsInt.colorWhite;
                    } else if (isAbcent) {
                      colorBox = ColorsInt.colorMissed;
                      colorText = ColorsInt.colorWhite;
                    } else if (isLeav) {
                      colorBox = ColorsInt.colorTextHint;
                      colorText = ColorsInt.colorWhite;
                    } else if (isToday) {
                      colorBox = ColorsInt.colorPrimary;
                      colorText = ColorsInt.colorWhite;
                    }

                    return new InkWell(
                      onTap: () =>
                          onDateSelected(calendarModel, attendanceModel),
                      child: new Container(
                        alignment: Alignment.center,
                        child: new Visibility(
                          visible: (calendarModel.month == selectedMonth),
                          child: Card(
                            elevation: 0.0,
                            color: colorBox,
                            child: new Container(
                              alignment: Alignment.center,
                              child: Text(
                                "${NumberFormat("00").format(calendarModelList[position].day)}",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: "regular",
                                  color: colorText,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }),
            //_getSwipeCalender(2, 12),
            new Container(
              width: double.infinity,
              color: ColorsInt.colorWhite,
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5.0),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorsInt.colorAttended,
                          ),
                          child: new Text(
                            totalAttended,
                            style: TextStyle(
                              color: ColorsInt.colorWhite,
                              fontSize: 14.0,
                              fontFamily: "regular",
                            ),
                          ),
                        ),
                        new Flexible(
                          child: new Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: new Text(
                              AppLocalizations.of(context)
                                  .translate("attended"),
                              style: TextStyle(
                                color: ColorsInt.colorText,
                                fontSize: 14.0,
                                fontFamily: "regular",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  new Expanded(
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5.0),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorsInt.colorMissed,
                          ),
                          child: new Text(
                            totalMissed,
                            style: TextStyle(
                              color: ColorsInt.colorWhite,
                              fontSize: 14.0,
                              fontFamily: "regular",
                            ),
                          ),
                        ),
                        new Flexible(
                            child: new Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: new Text(
                            AppLocalizations.of(context).translate("missed"),
                            style: TextStyle(
                              color: ColorsInt.colorText,
                              fontSize: 14.0,
                              fontFamily: "regular",
                            ),
                          ),
                        )),
                      ],
                    ),
                    flex: 1,
                  ),
                  new Expanded(
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5.0),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorsInt.colorTextHint,
                          ),
                          child: new Text(
                            totalUnspecified,
                            style: TextStyle(
                              color: ColorsInt.colorWhite,
                              fontSize: 14.0,
                              fontFamily: "regular",
                            ),
                          ),
                        ),
                        new Flexible(
                            child: new Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: new Text(
                            AppLocalizations.of(context)
                                .translate("unspecified"),
                            style: TextStyle(
                              color: ColorsInt.colorText,
                              fontSize: 14.0,
                              fontFamily: "regular",
                            ),
                          ),
                        )),
                      ],
                    ),
                    flex: 1,
                  )
                ],
              ),
            ),
            new Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                child: new Text(
                  AppLocalizations.of(context).translate("attendance_note"),
                  style: TextStyle(
                      fontFamily: "regular", color: ColorsInt.colorText),
                )),
          ],
        ),
      ],
    );
  }

  _getSwipeCalender(currentMonth, currentDay) {
    return new Container(
      height: 300.0,
      child: new Swiper(
        itemCount: 5,
        loop: false,
        pagination: new SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: const DotSwiperPaginationBuilder(
              activeColor: ColorsInt.colorGreen,
              color: ColorsInt.colorTextHint,
              size: 0.0,
              activeSize: 0.0),
        ),
        itemBuilder: (BuildContext context, int index) {
          return new OrientationBuilder(builder: (context, orientation) {
            var isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            return new GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: (isPortrait)
                      ? (MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2))
                      : 1,
                ),
                itemCount: calendarModelList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, position) {
                  var calendarModel = calendarModelList[position];

                  var colorBox = Colors.transparent;
                  var colorText = ColorsInt.colorText;
                  var isToday = false;
                  var isAttended = false;
                  var isAbcent = false;
                  var isLeav = false;
                  if (int.parse(selectedYear) == now.year &&
                      selectedMonth == currentMonth) {
                    if (calendarModel.day == currentDay) {
                      isToday = true;
                    }
                  }
                  var attendanceModel = _getAttendanceDetailByDate(
                      "${calendarModel.year}-${NumberFormat("00").format(calendarModel.month)}-${NumberFormat("00").format(calendarModel.day)}");
                  if (attendanceModel != null) {
                    isAttended = (attendanceModel.attended == "attended");
                    isAbcent = (attendanceModel.attended == "absent");
                    isLeav = (attendanceModel.attended == "leave");
                  }

                  if (isAttended) {
                    colorBox = ColorsInt.colorAttended;
                    colorText = ColorsInt.colorWhite;
                  } else if (isAbcent) {
                    colorBox = ColorsInt.colorMissed;
                    colorText = ColorsInt.colorWhite;
                  } else if (isLeav) {
                    colorBox = ColorsInt.colorTextHint;
                    colorText = ColorsInt.colorWhite;
                  } else if (isToday) {
                    colorBox = ColorsInt.colorPrimary;
                    colorText = ColorsInt.colorWhite;
                  }

                  return new InkWell(
                    onTap: () => onDateSelected(calendarModel, attendanceModel),
                    child: new Container(
                      alignment: Alignment.center,
                      child: new Visibility(
                        visible: (calendarModel.month == selectedMonth),
                        child: Card(
                          elevation: 0.0,
                          color: colorBox,
                          child: new Container(
                            alignment: Alignment.center,
                            child: Text(
                              "${NumberFormat("00").format(calendarModelList[position].day)}",
                              style: TextStyle(
                                fontSize: 22.0,
                                fontFamily: "regular",
                                color: colorText,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          });
        },
      ),
    );
  }

  _getTopDays() {
    List<Widget> widgets = [];
    for (int i = 0; i < calendarTopDays.length; i++) {
      var title = calendarTopDays[i];
      widgets.add(new Expanded(
        child: new Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: new Text(
            title ?? "",
            style: TextStyle(
              fontSize: 18,
              fontFamily: "regular",
              color: ColorsInt.colorWhite,
            ),
          ),
        ),
        flex: 1,
      ));
    }
    return widgets;
  }

  AttendanceModel _getAttendanceDetailByDate(String date) {
    for (AttendanceModel attendanceModel in attendanceModelList) {
      if (attendanceModel.date == date) {
        return attendanceModel;
      }
    }
    return null;
  }
}
