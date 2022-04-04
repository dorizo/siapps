import 'dart:convert';

import 'package:classes_app/models/AttendanceModel.dart';
import 'package:classes_app/models/StudentAttendanceTotalModel.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:flutter/material.dart';
import 'package:classes_app/screens/attendance/Body.dart';
import 'package:classes_app/models/CalendarModel.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:classes_app/models/BatchModel.dart';
import 'package:dio/dio.dart';
import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/components/CustomLoader.dart';
import 'package:classes_app/utils/CallApi.dart';
import 'package:classes_app/utils/DateFormatter.dart';
import 'package:classes_app/utils/app_localizations.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;
  SharedPreferences sharedPrefs;

  //Sun,Mon,Tue,Wed,Thu,Fri,Sat
  String CALENDAR_START_DAY = "Mon";

  static DateTime now = new DateTime.now();
  static int currentMonth = (now.month + 1);
  List<CalendarModel> _calendarModelList = [];
  List<String> _calendarTopDays = [];

  List<String> _monthList = [];
  List<String> _yearList = [];
  List<String> _classList = [];

  List<BatchModel> _batchesModelList = [];
  List<StudentAttendanceTotalModel> _studentAttendanceTotalModelList = [];
  List<AttendanceModel> _attendanceModelList = [];

  List<int> _monthListInt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  int _selectedMonth = now.month;
  String _selectedYear = now.year.toString();
  String _selectedClasses = "";
  String _selectedClassesID = "";
  String _totalAttended = "0";
  String _totalMissed = "0";
  String _totalUnspecified = "0";

  var pastMontDate = (now.month == 1)
      ? new DateTime(now.year - 1, 13, 0)
      : new DateTime(now.year, (currentMonth - 1), 0);
  var currentMonthDate = new DateTime(now.year, currentMonth, 0);
  var nextMonthDate = new DateTime(now.year, (currentMonth + 1), 0);

  @override
  void initState() {
    super.initState();
    _classList.clear();

    Future.delayed(Duration.zero, () {
      for (int i = 1; i <= 12; i++) {
        _monthList
            .add(new DateFormat('MMMM').format(new DateTime(now.year, i, 1)));
      }

      for (int i = 2016; i <= now.year; i++) {
        _yearList.add(new DateFormat('yyyy').format(new DateTime(i, 1)));
      }
      SharedPreferences.getInstance().then((prefs) {
        setState(() => sharedPrefs = prefs);
        if (sharedPrefs.containsKey("batches_list")) {
          print(sharedPrefs.containsKey("batches_list"));
          final List studentList =
              jsonDecode(sharedPrefs.getString("batches_list"));
          _batchesModelList.addAll(
              studentList.map((val) => BatchModel.fromJson(val)).toList());
          if (_batchesModelList.length > 0) {
            _selectedClasses = _batchesModelList[0].batch_name;
            _selectedClassesID = _batchesModelList[0].batch_id;
            for (int i = 0; i < _batchesModelList.length; i++) {
              _classList.add(_batchesModelList[i].batch_name);
            }
          }
        }
        _makeGetAttendanceTotals(context);
      });

      _bindTopDays();
      _bindDateList(currentMonthDate.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(pastMontDate.day);
    // print(currentMonthDate.day);
    // print(nextMonthDate.day);
    // print(DateTime.now().month + 1);

    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("attendance")),
        backgroundColor: ColorsInt.colorPrimary,
      ),
      body: new Body(
        totalAttended: _totalAttended,
        totalMissed: _totalMissed,
        totalUnspecified: _totalUnspecified,
        selectedMonth: _selectedMonth,
        selectedYear: _selectedYear,
        selectedClasses: _selectedClasses,
        monthList: _monthList,
        yearList: _yearList,
        classList: _classList,
        calendarTopDays: _calendarTopDays,
        calendarModelList: _calendarModelList,
        attendanceModelList: _attendanceModelList,
        onMonthSelected: (int newValue) {
          setState(() {
            var isNew = (_selectedMonth != newValue);
            _selectedMonth = newValue;
            if (isNew) {
              _bindDateList(0);
              _makeGetAttendanceTotals(context);
            }
          });
        },
        onYearSelected: (String newValue) {
          setState(() {
            var isNew = (_selectedYear != newValue);
            _selectedYear = newValue;
            if (isNew) {
              _bindDateList(0);
              _makeGetAttendanceTotals(context);
            }
          });
        },
        onClassesSelected: (String newValue) {
          setState(() {
            var selectedBatch = _getBatchDetailByName(newValue);
            if (selectedBatch != null) {
              var isNew = (_selectedClasses != newValue);
              _selectedClasses = newValue;
              _selectedClassesID = selectedBatch.batch_id;
              if (isNew) {
                _makeGetAttendanceTotals(context);
              }
            }
          });
        },
        onDateSelected:
            (CalendarModel calendarModel, AttendanceModel attendancemodel) {
          if (attendancemodel != null &&
              (attendancemodel.leave_note != null &&
                  attendancemodel.leave_note.toString().trim().isNotEmpty)) {
            _showAttendanceNote(attendancemodel);
          }
        },
      ),
    );
  }

  _makeGetAttendanceTotals(BuildContext context) {
    var url = BaseURL.GET_ATTENDANCE_TOTAL_LIST_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);
    map['month'] = DateFormatter.getConvetedDate(
        "${now.year}-${_selectedMonth.toString()}-1", 1);
    map['year'] = _selectedYear;
    map['batch'] = _selectedClassesID;

    CallApi().post(context, url, map, true).then((response) {
      final List dataJson = json.decode(response);
      setState(() {
        if (_studentAttendanceTotalModelList.length > 0) {
          _studentAttendanceTotalModelList.clear();
        }
        _studentAttendanceTotalModelList.addAll(dataJson
            .map((val) => StudentAttendanceTotalModel.fromJson(val))
            .toList());

        if (_studentAttendanceTotalModelList.length > 0) {
          var studentAttendaceTotalModel = _studentAttendanceTotalModelList[0];
          setState(() {
            _totalAttended = studentAttendaceTotalModel.total_attended;
            _totalMissed = studentAttendaceTotalModel.total_absent;
            _totalUnspecified = studentAttendaceTotalModel.total_leave;
          });
        }
      });
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });

    _makeGetAttendance(context);
  }

  _makeGetAttendance(BuildContext context) {
    var url = BaseURL.GET_ATTENDANCE_LIST_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);
    map['month'] = DateFormatter.getConvetedDate(
        "${now.year}-${_selectedMonth.toString()}-1", 1);
    map['year'] = _selectedYear;
    map['batch'] = _selectedClassesID;

    setState(() {
      if (_attendanceModelList.length > 0) {
        _attendanceModelList.clear();
      }
    });

    CallApi().post(context, url, map, true).then((response) {
      final List dataJson = json.decode(response);
      setState(() {
        if (_attendanceModelList.length > 0) {
          _attendanceModelList.clear();
        }
        _attendanceModelList.addAll(
            dataJson.map((val) => AttendanceModel.fromJson(val)).toList());
      });
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  BatchModel _getBatchDetailByName(String name) {
    for (BatchModel batchModel in _batchesModelList) {
      if (batchModel.batch_name == name) {
        return batchModel;
      }
    }
    return null;
  }

  _bindDateList(int currentMothTotal2) {
    //var seelectedMonthDate = new DateTime(now.year, currentMonth, 0);
    final DateTime date =
        new DateTime(int.parse(_selectedYear), _selectedMonth);
    var beginningNextMonth = (date.month < 12) ? new DateTime(date.year, date.month + 1, 1) : new DateTime(date.year + 1, 1, 1);
    var currentMothTotal = beginningNextMonth.subtract(new Duration(days: 1)).day;


    setState(() {
      _calendarModelList.clear();
    });

    List<CalendarModel> calendarModelList = [];

    var currentMonthDate =
        new DateTime(int.parse(_selectedYear), _selectedMonth, 1);

    for (int i = 1; i <= currentMothTotal; i++) {
      calendarModelList.add(new CalendarModel(
          int.parse(NumberFormat("00").format(i)),
          int.parse(NumberFormat("00").format(_selectedMonth)),
          int.parse(_selectedYear)));
    }

    var insertDateFirstDay = currentMonthDate.weekday;

    var currentMonthLastDate = new DateTime(
        int.parse(_selectedYear), _selectedMonth, currentMothTotal);
    var dsd = new DateFormat('E').format(currentMonthLastDate);

    var insertDateLastDay = currentMonthLastDate.weekday;
    // print("insertDateFirstDay: $insertDateFirstDay");
    // print("insertDateLastDay: ${dsd}");
    // print("insertDateLastDay2: ${insertDateLastDay}");

    int firstAddCell = 0;
    int lastAddCell = 0;

    if (CALENDAR_START_DAY == "Sun") {
      if (insertDateFirstDay == 1) {
        firstAddCell = 1;
      } else if (insertDateFirstDay == 2) {
        firstAddCell = 2;
      } else if (insertDateFirstDay == 3) {
        firstAddCell = 3;
      } else if (insertDateFirstDay == 4) {
        firstAddCell = 4;
      } else if (insertDateFirstDay == 5) {
        firstAddCell = 5;
      } else if (insertDateFirstDay == 6) {
        firstAddCell = 6;
      }

      if (insertDateLastDay == 0) {
        lastAddCell = 6;
      } else if (insertDateLastDay == 1) {
        lastAddCell = 5;
      } else if (insertDateLastDay == 2) {
        lastAddCell = 4;
      } else if (insertDateLastDay == 3) {
        lastAddCell = 3;
      } else if (insertDateLastDay == 4) {
        lastAddCell = 2;
      } else if (insertDateLastDay == 5) {
        lastAddCell = 1;
      }
    } else if (CALENDAR_START_DAY == "Mon") {
      if (insertDateFirstDay == 0) {
        firstAddCell = 6;
      } else if (insertDateFirstDay == 2) {
        firstAddCell = 1;
      } else if (insertDateFirstDay == 3) {
        firstAddCell = 2;
      } else if (insertDateFirstDay == 4) {
        firstAddCell = 3;
      } else if (insertDateFirstDay == 5) {
        firstAddCell = 4;
      } else if (insertDateFirstDay == 6) {
        firstAddCell = 5;
      }

      if (insertDateLastDay == 1) {
        lastAddCell = 6;
      } else if (insertDateLastDay == 2) {
        lastAddCell = 5;
      } else if (insertDateLastDay == 3) {
        lastAddCell = 4;
      } else if (insertDateLastDay == 4) {
        lastAddCell = 3;
      } else if (insertDateLastDay == 5) {
        lastAddCell = 2;
      } else if (insertDateLastDay == 6) {
        lastAddCell = 1;
      }
    }

    var pastMontDate = (_selectedMonth == 1)
        ? new DateTime(int.parse(_selectedYear) - 1, 13, 0)
        : new DateTime(int.parse(_selectedYear), (_selectedMonth - 1), 0);

    for (int i = pastMontDate.day; i > pastMontDate.day - firstAddCell; i--) {
      calendarModelList.insert(
          0,
          new CalendarModel(
              int.parse(NumberFormat("00").format(i)),
              int.parse(NumberFormat("00").format(pastMontDate.month)),
              pastMontDate.year));
    }

    var nextMontDate = (_selectedMonth == 12)
        ? new DateTime(int.parse(_selectedYear) + 1, 1, 1)
        : new DateTime(int.parse(_selectedYear), (_selectedMonth + 1), 1);

    for (int i = 1; i <= lastAddCell; i++) {
      calendarModelList.insert(
          calendarModelList.length,
          new CalendarModel(
              int.parse(NumberFormat("00").format(i)),
              int.parse(NumberFormat("00").format(nextMontDate.month)),
              nextMontDate.year));
    }

    // print("monthCurrent:$_selectedMonth");
    // print("monthPrev:${(_selectedMonth - 1)}");
    // print("monthNext:${(_selectedMonth + 1)}");

    setState(() {
      _calendarModelList.addAll(calendarModelList);
    });
  }

  _bindTopDays() {
    List<String> calendarTopDays = [];

    setState(() {
      _calendarTopDays.clear();
    });

    if (CALENDAR_START_DAY == "Sun") {
      calendarTopDays.add(AppLocalizations.of(context).translate("sun"));
      calendarTopDays.add(AppLocalizations.of(context).translate("mon"));
      calendarTopDays.add(AppLocalizations.of(context).translate("tue"));
      calendarTopDays.add(AppLocalizations.of(context).translate("wed"));
      calendarTopDays.add(AppLocalizations.of(context).translate("thu"));
      calendarTopDays.add(AppLocalizations.of(context).translate("fri"));
      calendarTopDays.add(AppLocalizations.of(context).translate("sat"));
    } else if (CALENDAR_START_DAY == "Mon") {
      calendarTopDays.add(AppLocalizations.of(context).translate("mon"));
      calendarTopDays.add(AppLocalizations.of(context).translate("tue"));
      calendarTopDays.add(AppLocalizations.of(context).translate("wed"));
      calendarTopDays.add(AppLocalizations.of(context).translate("thu"));
      calendarTopDays.add(AppLocalizations.of(context).translate("fri"));
      calendarTopDays.add(AppLocalizations.of(context).translate("sat"));
      calendarTopDays.add(AppLocalizations.of(context).translate("sun"));
    } else if (CALENDAR_START_DAY == "Tue") {
      calendarTopDays.add(AppLocalizations.of(context).translate("tue"));
      calendarTopDays.add(AppLocalizations.of(context).translate("wed"));
      calendarTopDays.add(AppLocalizations.of(context).translate("thu"));
      calendarTopDays.add(AppLocalizations.of(context).translate("fri"));
      calendarTopDays.add(AppLocalizations.of(context).translate("sat"));
      calendarTopDays.add(AppLocalizations.of(context).translate("sun"));
      calendarTopDays.add(AppLocalizations.of(context).translate("mon"));
    } else if (CALENDAR_START_DAY == "Wed") {
      calendarTopDays.add(AppLocalizations.of(context).translate("wed"));
      calendarTopDays.add(AppLocalizations.of(context).translate("thu"));
      calendarTopDays.add(AppLocalizations.of(context).translate("fri"));
      calendarTopDays.add(AppLocalizations.of(context).translate("sat"));
      calendarTopDays.add(AppLocalizations.of(context).translate("sun"));
      calendarTopDays.add(AppLocalizations.of(context).translate("mon"));
      calendarTopDays.add(AppLocalizations.of(context).translate("tue"));
    } else if (CALENDAR_START_DAY == "Thu") {
      calendarTopDays.add(AppLocalizations.of(context).translate("thu"));
      calendarTopDays.add(AppLocalizations.of(context).translate("fri"));
      calendarTopDays.add(AppLocalizations.of(context).translate("sat"));
      calendarTopDays.add(AppLocalizations.of(context).translate("sun"));
      calendarTopDays.add(AppLocalizations.of(context).translate("mon"));
      calendarTopDays.add(AppLocalizations.of(context).translate("tue"));
      calendarTopDays.add(AppLocalizations.of(context).translate("wed"));
    } else if (CALENDAR_START_DAY == "Fri") {
      calendarTopDays.add(AppLocalizations.of(context).translate("fri"));
      calendarTopDays.add(AppLocalizations.of(context).translate("sat"));
      calendarTopDays.add(AppLocalizations.of(context).translate("sun"));
      calendarTopDays.add(AppLocalizations.of(context).translate("mon"));
      calendarTopDays.add(AppLocalizations.of(context).translate("tue"));
      calendarTopDays.add(AppLocalizations.of(context).translate("wed"));
      calendarTopDays.add(AppLocalizations.of(context).translate("thu"));
    } else if (CALENDAR_START_DAY == "Sat") {
      calendarTopDays.add(AppLocalizations.of(context).translate("sat"));
      calendarTopDays.add(AppLocalizations.of(context).translate("sun"));
      calendarTopDays.add(AppLocalizations.of(context).translate("mon"));
      calendarTopDays.add(AppLocalizations.of(context).translate("tue"));
      calendarTopDays.add(AppLocalizations.of(context).translate("wed"));
      calendarTopDays.add(AppLocalizations.of(context).translate("thu"));
      calendarTopDays.add(AppLocalizations.of(context).translate("fri"));
    }

    setState(() {
      _calendarTopDays.addAll(calendarTopDays);
    });
  }

  _showAttendanceNote(AttendanceModel attendanceModel) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              content: new Container(
                color: Colors.transparent,
                child: new Container(
                  decoration: new BoxDecoration(
                      color: ColorsInt.colorWhite,
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(8.0))),
                  padding: EdgeInsets.all(10.0),
                  child: new Text(
                    attendanceModel.leave_note,
                    style: new TextStyle(
                      color: ColorsInt.colorText,
                      fontFamily: "regular",
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ));
        });
  }

  bool isDialogShowing = false;

  void _showLoading() {
    if (_loading) {
      isDialogShowing = true;
      var loaderDialog = showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new CustomLoader();
          });
    } else {
      if (isDialogShowing) {
        Navigator.of(context).pop();
        isDialogShowing = false;
      }
    }
  }

  _displaySnackBar(BuildContext context, String message) {
    if (_scaffoldKey != null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }
}
