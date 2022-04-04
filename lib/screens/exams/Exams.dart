import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:classes_app/screens/exams/bodys/BodyExams.dart';
import 'package:classes_app/screens/exams/ExamStart.dart';
import 'package:classes_app/screens/exams/ExamResult.dart';
import 'package:classes_app/screens/exams/ExamOfflineResult.dart';

import 'package:classes_app/models/ExamModel.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/utils/CallApi.dart';
import 'package:classes_app/utils/DateFormatter.dart';

class Exams extends StatefulWidget {
  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<Exams>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  TabController _controller;

  List<ExamModel> _offlineExamModelList = [];
  List<ExamModel> _onlineExamModelList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = new TabController(length: 2, vsync: this);
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      makeGetOfflineExamList(context);
      makeGetOnlineExamList(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app
      print("resumed");
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
      print("inactive");
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
      print("paused");
    }
  }

  void goToSecondScreen(ExamModel examModel, String examType) async {
    if (examType == "2" &&
        examModel.attempt_id != null &&
        examModel.attempt_id.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExamResult(
                    examModel: examModel,
                  )));
      //goToNext(examModel);
    } else if (examType == "1" &&
        examModel.total_obtain_marks != null &&
        examModel.total_obtain_marks.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExamOfflineResult(
                    examModel: examModel,
                  )));
      //goToNext(examModel);
    } else if (examModel.attempt_id == null) {
      if (examModel.exam_on_schedule == "0" &&
          DateFormatter.isDateValid(examModel.exam_date)) {
        if (sharedPrefs.getInt(BaseURL.KEY_LOGIN_TYPE) == 1) {
          var result = await Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new ExamStart(
                  examModel: examModel,
                ),
                fullscreenDialog: false,
              ));
          if (result == "true" && sharedPrefs != null) {
            makeGetOfflineExamList(context);
            makeGetOnlineExamList(context);
          }
        }
      } else {
        if (DateFormatter.isDateValid(examModel.exam_date) &&
            DateFormatter.isTimeValid(examModel.exam_start_time,
                int.parse(examModel.exam_schedule_min))) {
          if (sharedPrefs.getInt(BaseURL.KEY_LOGIN_TYPE) == 1) {
            var result = await Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (BuildContext context) => new ExamStart(
                    examModel: examModel,
                  ),
                  fullscreenDialog: false,
                ));
            if (result == "true" && sharedPrefs != null) {
              makeGetOfflineExamList(context);
              makeGetOnlineExamList(context);
            }
          }
        } else {
          _displaySnackBar(context,
              "${AppLocalizations.of(context).translate("this_exam_you_can_attempt")} ${DateFormatter.getConvetedDate(examModel.exam_date, 4)}");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("exams")),
        backgroundColor: ColorsInt.colorPrimary,
        elevation: 0.0,
      ),
      body: new BodyExams(
        controller: _controller,
        offlineExamModelList: _offlineExamModelList,
        onlineExamModelList: _onlineExamModelList,
        goToNext: (exam, type) => goToSecondScreen(exam, type),
      ),
    );
  }

  makeGetOfflineExamList(BuildContext context) {
    var url = BaseURL.GET_EXAM_OFFLINE_LIST_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);

    CallApi().post(context, url, map, true).then((response) {
      final List dataJson = json.decode(response);
      setState(() {
        _offlineExamModelList.clear();
        _offlineExamModelList
            .addAll(dataJson.map((val) => ExamModel.fromJson(val)).toList());
      });
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  makeGetOnlineExamList(BuildContext context) {
    var url = BaseURL.GET_EXAM_ONLINE_LIST_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);

    CallApi().post(context, url, map, true).then((response) {
      final List dataJson = json.decode(response);
      setState(() {
        _onlineExamModelList.clear();
        _onlineExamModelList
            .addAll(dataJson.map((val) => ExamModel.fromJson(val)).toList());
      });
    }, onError: (error) {
      //_displaySnackBar(context, error.toString());
    });
  }

  _displaySnackBar(BuildContext context, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
