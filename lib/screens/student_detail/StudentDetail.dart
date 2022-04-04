import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:classes_app/screens/student_detail/Body.dart';

import 'package:classes_app/models/StudentModel.dart';
import 'package:classes_app/models/ParentModel.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/utils/CallApi.dart';

class StudentDetail extends StatefulWidget {
  StudentDetail({Key key, this.studentModel}) : super(key: key);

  StudentModel studentModel;

  @override
  _StudentDetailState createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  String _totalAttended = "";
  String _totalLeave = "";
  List<ParentModel> _parentModelList = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      _makeGetStudentDetail(context);
    });
  }

  _callClick() async {
    final callurl = "tel:${widget.studentModel.stud_contact}";
    if (await canLaunch(callurl)) {
      await launch(callurl);
    } else {
      throw 'Could not launch $callurl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("student")),
        backgroundColor: ColorsInt.colorPrimary,
        elevation: 0.0,
      ),
      body: Body(
        studentModel: widget.studentModel,
        parentModelList: _parentModelList,
        totalAttended: _totalAttended,
        totalLeave: _totalLeave,
        callClick: () => _callClick(),
      ),
    );
  }

  _makeGetStudentDetail(BuildContext context) {
    var url = BaseURL.GET_STUDENT_LIST_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);

    CallApi().post(context, url, map, true).then((response) {
      final Map dataJson = json.decode(response);
      final List parentsList = dataJson["parents"];
      final List attendanceList = dataJson["attendance"];
      setState(() {
        widget.studentModel = StudentModel.fromJson(dataJson);

        if (_parentModelList.length > 0) {
          _parentModelList.clear();
        }
        _parentModelList.addAll(
            parentsList.map((val) => ParentModel.fromJson(val)).toList());

        for (int i = 0; i < attendanceList.length; i++) {
          Map jsonObject = attendanceList[i];
          if (jsonObject["attended"] == "attended") {
            _totalAttended = jsonObject["totals"];
          } else if (jsonObject["attended"] == "leave") {
            _totalLeave = jsonObject["totals"];
          }
        }
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
