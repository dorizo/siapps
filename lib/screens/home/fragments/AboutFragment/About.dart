import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:classes_app/screens/home/fragments/AboutFragment/Body.dart';

import 'package:classes_app/models/ClassesModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/utils/CallApi.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutPage();
  }
}

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  ClassesModel _classesModel;

  double _webHeight = 100.0;
  InAppWebViewController _controller;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      _makeGetClassesDetail(context);
    });
  }

  _emailClick() async {
    final email = "mailto:${_classesModel.classis_email}";
    if (await canLaunch(email)) {
      await launch(email);
    } else {
      throw 'Could not launch $email';
    }
  }

  _callClick() async {
    final callurl = "tel:${_classesModel.classis_phone_no}";
    if (await canLaunch(callurl)) {
      await launch(callurl);
    } else {
      throw 'Could not launch $callurl';
    }
  }

  _siteClick() async {
    String url = "${_classesModel.classis_website}";
    if (!url.contains("http")) {
      url = "http://$url";
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _mapClick() async {
    String url =
        "http://maps.google.com/maps?daddr=20.5666,45.345";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _setWebHeight(double height) {
    print("height::$height");
    setState(() {
      _webHeight = height;
    });
  }

  _setWebController(InAppWebViewController controller) {
    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: null,
      body: new Body(
        classesModel: _classesModel,
        webHeight: _webHeight,
        controller: _controller,
        emailClick: () => _emailClick(),
        callClick: () => _callClick(),
        siteClick: () => _siteClick(),
        mapClick: () => _mapClick(),
        setWebHeight: (height) => _setWebHeight(height),
        setWebController: (controller) => _setWebController(controller),
      ),
    );
  }

  _makeGetClassesDetail(BuildContext context) {
    var url = BaseURL.GET_CLASSES_DETAIL_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);

    CallApi().post(context, url, map, true).then((response) {
      final Map dataJson = json.decode(response);
      setState(() {
        _classesModel = ClassesModel.fromJson(dataJson);
      });
    }, onError: (error) {
      CallApi().displaySnackBar(context, error.toString());
    });
  }
}
