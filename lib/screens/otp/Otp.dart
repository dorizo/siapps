import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:classes_app/screens/login/Login.dart';
import 'package:classes_app/screens/otp/Body.dart';
import 'package:classes_app/models/StudentModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/CallApi.dart';

class Otp extends StatefulWidget {
  Otp({Key key, this.mobile}) : super(key: key);

  String mobile;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  List<StudentModel> _studentList = [];

  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
    });
  }

  _submitClick(String otp) {
    print(otp);
    makeGetExamDetail(context, widget.mobile, otp);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Password Parent"),
        backgroundColor: ColorsInt.colorPrimary,
        elevation: 0.0,
      ),
      body: new Body(
        errorController: errorController,
        textEditingController: textEditingController,
        submitClick: (otp) => _submitClick(otp),
      ),
    );
  }

  makeGetExamDetail(BuildContext context, String mobile, String otp) {
    var url = BaseURL.VERIFY_MOBILE_URL;
    var map = new Map<String, String>();
    map['mobile'] = mobile;
    map['otp'] = otp;

    CallApi().post(context, url, map, true).then((response) {
      final List dataJson = json.decode(response);
      setState(() {
        _studentList.clear();
        _studentList
            .addAll(dataJson.map((val) => StudentModel.fromJson(val)).toList());

        sharedPrefs.setString("studentList", json.encode(dataJson).toString());

        print(sharedPrefs.getString("studentList"));

        _bottomSheetStudentList(context);
      });
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  void _bottomSheetStudentList(context) {
    List<Widget> _studentListWidget = [];
    for (int i = 0; i < _studentList.length; i++) {
      var studentModel = _studentList[i];
      _studentListWidget.add(
        new Column(children: <Widget>[
          new Container(
            padding: EdgeInsets.all(5.0),
            child: new ListTile(
                leading: new Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorsInt.colorDivider,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                          BaseURL.IMG_STUDENT + studentModel.stud_photo),
                    ),
                  ),
                ),
                title: new Text(studentModel.stud_first_name),
                onTap: () => {_storeSession(studentModel.toMap())}),
          ),
          new Divider(
            color: ColorsInt.colorDivider,
          )
        ]),
      );
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: _studentListWidget,
            ),
          );
        });
  }

  _storeSession(Map data) async {
    // set value
    sharedPrefs.setString("parent_id", data["parent_id"].toString());
    sharedPrefs.setString(
        "parent_fullname", data["parent_fullname"].toString());

    sharedPrefs.setString(BaseURL.KEY_USER_ID, data["student_id"].toString());
    sharedPrefs.setString(
        BaseURL.KEY_USER_NAME, data["stud_first_name"].toString());
    sharedPrefs.setString(
        BaseURL.KEY_STATUS, data[BaseURL.KEY_STATUS].toString());
    sharedPrefs.setString(
        BaseURL.KEY_USER_TYPE, data[BaseURL.KEY_USER_TYPE].toString());
    sharedPrefs.setString(
        BaseURL.KEY_STUDENT_DETAIL, json.encode(data).toString());
    sharedPrefs.setInt(BaseURL.KEY_LOGIN_TYPE, 2);
    sharedPrefs.setBool(BaseURL.KEY_IS_LOGIN, true);

    sharedPrefs.setString("studentData", json.encode(data).toString());

    _goNext();
  }

  _goNext() async {
    if (sharedPrefs != null &&
        sharedPrefs.containsKey(BaseURL.KEY_IS_LOGIN) &&
        sharedPrefs.getBool(BaseURL.KEY_IS_LOGIN)) {
      Route route = MaterialPageRoute(builder: (context) => Login());
      Navigator.pushAndRemoveUntil(
          context, route, ModalRoute.withName("/Home"));
    }
  }

  _displaySnackBar(BuildContext context, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
