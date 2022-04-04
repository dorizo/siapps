import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:classes_app/screens/classroom/body/Body.dart';

import 'package:classes_app/models/ClassRoomModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/CallApi.dart';
import 'package:classes_app/utils/app_localizations.dart';

class ClassRoom extends StatefulWidget {
  @override
  _ClassRoomState createState() => _ClassRoomState();
}

class _ClassRoomState extends State<ClassRoom> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  List<ClassRoomModel> _classRoomModelList = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      makeOnlineClassroom(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("class_rooms")),
        backgroundColor: ColorsInt.colorPrimary,
      ),
      body: new Body(
        classRoomModelList: _classRoomModelList,
      ),
    );
  }

  makeOnlineClassroom(BuildContext context) {
    var url = BaseURL.GET_ONLINE_CLASSROOM_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);

    CallApi().post(context, url, map, true).then((response) {
      final List dataJson = json.decode(response);
      setState(() {
        _classRoomModelList.clear();
        _classRoomModelList.addAll(
            dataJson.map((val) => ClassRoomModel.fromJson(val)).toList());
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
