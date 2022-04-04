import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:classes_app/screens/exams/bodys/BodyExamOfflineResult.dart';
import 'package:classes_app/models/ExamModel.dart';
import 'package:classes_app/models/ExamResultModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/CallApi.dart';

class ExamOfflineResult extends StatefulWidget {
  ExamOfflineResult({Key key, this.examModel}) : super(key: key);

  ExamModel examModel;

  @override
  _ExamOfflineResultState createState() => _ExamOfflineResultState();
}

class _ExamOfflineResultState extends State<ExamOfflineResult> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  List<ExamResultModel> _examResultModelList = [];
  double _totalMarks = 0.0;
  double _totalObtain = 0.0;
  double _totalPercentage = 0.0;

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
      body: new BodyExamOfflineResult(
        examModel: widget.examModel,
        examResultModelList: _examResultModelList,
        totalMarks: _totalMarks,
        totalObtain: _totalObtain,
        totalPercentage: _totalPercentage,
      ),
    );
  }

  makeGetExamDetail(BuildContext context) {
    var url = BaseURL.GET_EXAM_OFFLINE_DETAIL_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);
    map['exam_id'] = widget.examModel.exam_id;

    CallApi().post(context, url, map, true).then((response) {
      final Map dataJson = json.decode(response);
      final List resultArray = dataJson["result"];
      setState(() {
        _examResultModelList.clear();
        _examResultModelList.addAll(
            resultArray.map((val) => ExamResultModel.fromJson(val)).toList());

        double totalMarks = 0.0;
        double totalObtain = 0.0;
        for (int i = 0; i < _examResultModelList.length; i++) {
          ExamResultModel examResultModel = _examResultModelList[i];
          totalMarks += double.parse(examResultModel.total_marks);
          totalObtain += double.parse(examResultModel.obtain_marks);
        }

        _totalMarks = totalMarks;
        _totalObtain = totalObtain;

        _totalPercentage = _totalObtain * 100 / _totalMarks;
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
