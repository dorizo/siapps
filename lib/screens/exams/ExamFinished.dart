import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:classes_app/screens/exams/bodys/BodyExamFinished.dart';
import 'package:classes_app/screens/exams/ExamResult.dart';

import 'package:classes_app/models/ExamModel.dart';
import 'package:classes_app/models/ExamQuestionModel.dart';

class ExamFinished extends StatefulWidget {
  ExamFinished(
      {Key key,
      this.totalSpendSeconds,
      this.examModel,
      this.examQuestionModelList})
      : super(key: key);

  final int totalSpendSeconds;
  final ExamModel examModel;
  final List<ExamQuestionModel> examQuestionModelList;

  @override
  _ExamFinishedState createState() => _ExamFinishedState();
}

class _ExamFinishedState extends State<ExamFinished> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  String _totalQuestion = "";
  String _totalCurrectAnswer = "";
  String _totalWrongAnswer = "";
  String _totalSkipedAnswer = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
    });

    setState(() {
      _totalQuestion = widget.examQuestionModelList.length.toString();
      _totalCurrectAnswer = widget.examModel.total_correct;
      _totalWrongAnswer = widget.examModel.total_wrong;
      _totalSkipedAnswer = widget.examModel.total_skip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: null,
      body: new BodyExamFinished(
        totalSpendSeconds: widget.totalSpendSeconds,
        totalQuestion: _totalQuestion,
        totalCurrectAnswer: _totalCurrectAnswer,
        totalWrongAnswer: _totalWrongAnswer,
        totalSkipedAnswer: _totalSkipedAnswer,
        onResultClick: (){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ExamResult(
                    examModel: widget.examModel,
                  )));
        },
      ),
    );
  }
}
