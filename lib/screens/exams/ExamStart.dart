import 'package:classes_app/screens/exams/Examselesai.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'package:classes_app/screens/exams/bodys/BodyExamStart.dart';
import 'package:classes_app/screens/exams/ExamFinished.dart';

import 'package:classes_app/models/ExamModel.dart';
import 'package:classes_app/models/ExamQuestionModel.dart';
import 'package:classes_app/models/ExamQuestionOptionModel.dart';

import 'package:classes_app/components/CommonAlert.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/CallApi.dart';
import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/utils/DateFormatter.dart';

class ExamStart extends StatefulWidget {
  ExamStart({Key key, this.examModel}) : super(key: key);

  ExamModel examModel;

  @override
  _ExamStartState createState() => _ExamStartState();
}

class _ExamStartState extends State<ExamStart> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  String startTime = "";
  int _totalSeconds = 0;
  Timer _timer;
  int _seconds = 0;

  bool allowBack = false;

  List<ExamQuestionModel> _examQuestionModelList = [];

  int _currentQuestionPosition = 0;
  ExamQuestionModel _currentExamQuestionModel;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      makeGetExamDetail(context);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    int totalMinutes = int.parse(widget.examModel.exam_schedule_min);
    setState(() {
      _totalSeconds = totalMinutes * 60;
      _seconds = _totalSeconds;
    });
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_seconds < 1) {
            timer.cancel();
            _showTimeOutAlert(context);
          } else {
            _seconds = _seconds - 1;
          }
        },
      ),
    );
  }

  _ExamFinished() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ExamFinished()));
  }

  _prevClick() {
    if (_examQuestionModelList.length > 0 && _currentQuestionPosition != 0) {
      setState(() {
        _currentQuestionPosition--;
        _currentExamQuestionModel =
            _examQuestionModelList[_currentQuestionPosition];
      });
    }
  }

  _nextClick() {
    if (_examQuestionModelList.length > 0 &&
        _examQuestionModelList.length - 1 > _currentQuestionPosition) {
      setState(() {
        _currentQuestionPosition++;
        _currentExamQuestionModel =
            _examQuestionModelList[_currentQuestionPosition];
      });
    } else {
      
      makeSubmitExam(context, false);
      
    }
  }

  _answerClick(ExamQuestionOptionModel examQuestionOptionModel) {
    bool isExist = false;

    if (_currentExamQuestionModel.selectedIds != null) {}
    for (int i = 0; i < _currentExamQuestionModel.selectedIds.length; i++) {
      String id = _currentExamQuestionModel.selectedIds[i];
      if (id == examQuestionOptionModel.opt_id) {
        isExist = true;
        break;
      }
    }

    setState(() {
      if (_currentExamQuestionModel.que_ans_multiple == "0") {
        _currentExamQuestionModel.selectedIds.clear();
      }
      if (isExist) {
        _currentExamQuestionModel.selectedIds
            .remove(examQuestionOptionModel.opt_id);
      } else {
        _currentExamQuestionModel.selectedIds
            .add(examQuestionOptionModel.opt_id);
      }
    });
  }

  Future<bool> _onWillPop() async {
    _showExamFinishAlert(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(AppLocalizations.of(context).translate("ujian")),
          backgroundColor: ColorsInt.colorPrimary,
          elevation: 0.0,
        ),
        body: new BodyExamStart(
          examModel: widget.examModel,
          examQuestionModelList: _examQuestionModelList,
          currentQuestionPosition: _currentQuestionPosition,
          currentExamQuestionModel: _currentExamQuestionModel,
          seconds: _seconds,
          answerClick: (examQuestionOptionModel) =>
              _answerClick(examQuestionOptionModel),
          prevClick: () => _prevClick(),
          nextClick: () => _nextClick(),
          examFinished: () => _ExamFinished(),
        ),
      ),
    );
  }

  makeGetExamDetail(BuildContext context) {
    var url = BaseURL.GET_EXAM_ONLINE_DETAIL_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);
    map['exam_id'] = widget.examModel.exam_id;

    CallApi().post(context, url, map, true).then((response) {
      final Map dataJson = json.decode(response);
      startTime = DateFormatter.getCurrentTime();
      setState(() {
        widget.examModel = ExamModel.fromJson(dataJson);
        _examQuestionModelList.clear();
        _examQuestionModelList.addAll(widget.examModel.questions);
        _currentQuestionPosition = 0;
        if (_examQuestionModelList.length > 0) {
          _currentExamQuestionModel =
              _examQuestionModelList[_currentQuestionPosition];
        }
        startTimer();
      });
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  makeSubmitExam(BuildContext context, isTimeFinish) {

    

    _timer.cancel();

    List<Map<String, String>> jsonArray = [];
    for (int i = 0; i < _examQuestionModelList.length; i++) {
      final examQuestionModel = _examQuestionModelList[i];

      Map<String, String> jsonObject = new Map();
      jsonObject["id_bank_soal"] = examQuestionModel.que_id ?? "";
      jsonObject["id_question_bundle"] = examQuestionModel.exam_id ?? "";
      jsonObject["answer_scaduleid"] = examQuestionModel.classis_id;
      jsonObject["id_user"] = sharedPrefs.getString(BaseURL.KEY_USER_NAME);
      jsonObject["id_jawaban"] = examQuestionModel.selectedIds
      
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");
      jsonArray.add(jsonObject);
    }
    print("answer::" + json.encode(jsonArray));

    final totalSpendSeconds = _totalSeconds - _seconds;

    var url = BaseURL.SUBMIT_EXAM_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);
    map['exam_id'] = widget.examModel.exam_id;
    map['attempt_start_time'] = startTime;
    map['questions'] = json.encode(jsonArray);

    CallApi().post(context, url, map, true).then((response) {
      final Map dataJson = json.decode(response);
      print(isTimeFinish);


      // final examModel = ExamModel.fromJson(dataJson);
      // if (isTimeFinish) {
      //   setState(() {
      //     allowBack = false;
      //   });
      //   Navigator.pop(context, "true");
      // } else {
        Route route = MaterialPageRoute(
            builder: (context) =>Examselesai() );
        Navigator.pushReplacement(context, route, result: "true");
      // }
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  _showTimeOutAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new CommonAlert(
            message:
                AppLocalizations.of(context).translate("your_exam_time_is_up"),
            okClick: () {},
          );
        }).then((val) {
      makeSubmitExam(context, true);
    });
  }

  _showExamFinishAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new CommonAlert(
            message: AppLocalizations.of(context).translate(
                "are_you_sure_want_to_exist_and_submit_exam_you_are_not_able_to_give_exam_again"),
            cancelText:
                AppLocalizations.of(context).translate("yes").toUpperCase(),
            okText: AppLocalizations.of(context).translate("no").toUpperCase(),
            okClick: () {
              setState(() {
                allowBack = false;
              });
            },
            cancelClick: () {
                allowBack = false;
            },
          );
        });
  }

  _displaySnackBar(BuildContext context, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
