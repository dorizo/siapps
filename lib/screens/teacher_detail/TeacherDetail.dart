import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:classes_app/screens/teacher_detail/Body.dart';

import 'package:classes_app/models/TeacherModel.dart';
import 'package:classes_app/models/BatchModel.dart';

import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/utils/CallApi.dart';

class TeacherDetail extends StatefulWidget {
  TeacherDetail({Key key, this.teacherModel}) : super(key: key);

  TeacherModel teacherModel;

  @override
  _TeacherDetailState createState() => _TeacherDetailState();
}

class _TeacherDetailState extends State<TeacherDetail> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  List<BatchModel> _batchModelList = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      _makeGetTeacherDetail(context);
    });
    //Future.delayed(Duration(seconds: 2), () {});
  }

  _callClick() async {
    final callurl = "tel:${widget.teacherModel.teacher_phone}";
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
        title: new Text(AppLocalizations.of(context).translate("teacher")),
        backgroundColor: ColorsInt.colorPrimary,
        elevation: 0.0,
      ),
      body: Body(
        teacherModel: widget.teacherModel,
        batchModelList: _batchModelList,
        onCallClick: () => _callClick(),
      ),
    );
  }

  _makeGetTeacherDetail(BuildContext context) {
    var url = BaseURL.GET_TEACHER_BATCHES_URL;
    var map = new Map<String, String>();
    map['teacher_id'] = widget.teacherModel.teacher_id ?? "0";
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);

    CallApi().post(context, url, map, true).then((response) {
      final List dataJson = json.decode(response);
      setState(() {
        if (_batchModelList.length > 0) {
          _batchModelList.clear();
        }
        _batchModelList
            .addAll(dataJson.map((val) => BatchModel.fromJson(val)).toList());
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
