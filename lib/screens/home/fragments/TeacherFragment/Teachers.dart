import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:classes_app/screens/home/fragments/TeacherFragment/Body.dart';

import 'package:classes_app/models/TeacherModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/CallApi.dart';

class Teachers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TeachersPage();
  }
}

class TeachersPage extends StatefulWidget {
  @override
  _TeachersState createState() => _TeachersState();
}

class _TeachersState extends State<TeachersPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  List<TeacherModel> _teacherModelList = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      _makeGetTeacherList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: null,
      body: new Body(
        teacherModelList: _teacherModelList,
      ),
    );
  }

  _makeGetTeacherList(BuildContext context) {
    var url = BaseURL.GET_TEACHER_LIST_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);

    CallApi().post(context, url, map, true).then((response) {
      final List dataJson = json.decode(response);
      setState(() {
        if (_teacherModelList.length > 0) {
          _teacherModelList.clear();
        }
        _teacherModelList
            .addAll(dataJson.map((val) => TeacherModel.fromJson(val)).toList());
      });
    }, onError: (error) {
      CallApi().displaySnackBar(context, error.toString());
    });
  }
}
