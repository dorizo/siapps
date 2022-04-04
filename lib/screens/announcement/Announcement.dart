import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:classes_app/screens/announcement/BodyAnnouncement.dart';
import 'package:classes_app/models/AnnouncementModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/CallApi.dart';

class Announcement extends StatefulWidget {
  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  List<AnnouncementModel> _announcementModelList = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      makeGetAnnouncement(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("recent_announcement")),
        backgroundColor: ColorsInt.colorPrimary,
        elevation: 0.0,
      ),
      body: new BodyAnnouncement(
        announcementModelList: _announcementModelList,
      ),
    );
  }

  makeGetAnnouncement(BuildContext context) {
    var url = BaseURL.GET_ANNOUNCEMENT_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);

    CallApi().post(context, url, map, true).then((response) {
      final List dataJson = json.decode(response);
      setState(() {
        if (_announcementModelList.length > 0) {
          _announcementModelList.clear();
        }
        _announcementModelList.addAll(
            dataJson.map((val) => AnnouncementModel.fromJson(val)).toList());
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
