import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:classes_app/screens/exams/bodys/BodyExamResult.dart';

import 'package:classes_app/models/ExamModel.dart';
import 'package:classes_app/models/ExamQuestionModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/CallApi.dart';

class ExamResult extends StatefulWidget {
  ExamResult({Key key, this.examModel}) : super(key: key);

  ExamModel examModel;

  @override
  _ExamResultState createState() => _ExamResultState();
}

class _ExamResultState extends State<ExamResult> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  List<ExamQuestionModel> _examQuestionModelList = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      makeGetExamDetail(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.examModel.exam_title ?? ""),
        backgroundColor: ColorsInt.colorPrimary,
        elevation: 0.0,
      ),
      body: new BodyExamResult(
        examQuestionModelList: _examQuestionModelList,
      ),
    );
  }

  makeGetExamDetail(BuildContext context) {

    var url = BaseURL.GET_EXAM_ONLINE_DETAIL_URL;
    log(url);
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);
    map['exam_id'] = widget.examModel.exam_id;

    CallApi().post(context, url, map, true).then((response) {
      final Map dataJson = json.decode(response);
      setState(() {
        widget.examModel = ExamModel.fromJson(dataJson);
        _examQuestionModelList.clear();
        _examQuestionModelList.addAll(widget.examModel.questions);
      });
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  _displaySnackBar(BuildContext context, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
