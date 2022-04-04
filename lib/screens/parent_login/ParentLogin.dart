import 'package:flutter/material.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:classes_app/screens/otp/Otp.dart';
import 'package:classes_app/screens/login/Login.dart';
import 'package:classes_app/models/StudentModel.dart';

import 'package:classes_app/components/CustomLoader.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/CallApi.dart';

class ParentLogin extends StatefulWidget {
  @override
  _ParentLoginState createState() => _ParentLoginState();
}

class _ParentLoginState extends State<ParentLogin> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;
  bool _loading = false;

  final _mobileNumber = TextEditingController();
  bool _mobileNumberError = false;
  String _mobileNumberErrorMessage = "";
  List<StudentModel> _studentList = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(
          AppLocalizations.of(context).translate("mobile_verification"),
          style: TextStyle(
            fontFamily: "light",
          ),
        ),
        backgroundColor: ColorsInt.colorPrimary,
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            alignment: Alignment.topLeft,
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: new EdgeInsets.all(30),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          AppLocalizations.of(context)
                                  .translate("parent_login") +
                              ":",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorsInt.colorPrimary,
                            fontFamily: "bold",
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      new TextFormField(
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.bottom,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (term) {
                          _checkMobile(context);
                        },
                        maxLength: 14,
                        controller: _mobileNumber,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate("parent_mobile_number"),
                          prefixIcon:
                              Image.asset('assets/images/ic_user_name.png'),
                          errorText: _mobileNumberError
                              ? _mobileNumberErrorMessage
                              : null,
                        ),
                        style: TextStyle(
                          fontFamily: "regular",
                        ),
                      ),
                      new Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: new Text(
                          AppLocalizations.of(context)
                              .translate("parent_login_note1"),
                          style: TextStyle(
                              fontFamily: "regular",
                              color: ColorsInt.colorText,
                              fontSize: 12.0),
                        ),
                      ),
                      new InkWell(
                        onTap: () {
                          _checkMobile(context);
                        },
                        child: new Container(
                          width: double.infinity,
                          color: Colors.transparent,
                          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: new Container(
                            decoration: new BoxDecoration(
                              color: ColorsInt.colorPrimary,
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(8)),
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: new Center(
                              child: Text(
                                AppLocalizations.of(context).translate("login"),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "bold",
                                    color: ColorsInt.colorWhite),
                              ),
                            ),
                          ),
                        ),
                      ),
                      new Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: new Text(
                          AppLocalizations.of(context)
                              .translate("parent_login_note2"),
                          style: TextStyle(
                              fontFamily: "regular",
                              color: ColorsInt.colorText,
                              fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  _checkMobile(BuildContext context) {
    setState(() {
      _mobileNumberError = false;
    });

    var mobileNumber = _mobileNumber.text.toString();

    if (mobileNumber.isEmpty) {
      setState(() {
        _mobileNumberError = true;
        _mobileNumberErrorMessage =
            AppLocalizations.of(context).translate("error_required");
      });
    } else if (mobileNumber.length < 4) {
      setState(() {
        _mobileNumberError = true;
        _mobileNumberErrorMessage =
            AppLocalizations.of(context).translate("error_mobile_number");
      });
    } else {
      //Navigator.of(context).pop();
      makeLogin(context, mobileNumber);
      /*Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Otp(
                    mobile: mobileNumber,
                  )));*/
    }
  }

  Future<dynamic> makeLogin(BuildContext context, String mobile) async {
    FocusScope.of(context).requestFocus(FocusNode());

    var map = new Map<String, String>();
    map['mobile'] = mobile;

    CallApi().post(context, BaseURL.LOGIN_PARENT_URL, map, true).then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Otp(
                    mobile: mobile,
                  )));
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  Future<dynamic> makeVerifyMobile(BuildContext context, String mobile) async {
    FocusScope.of(context).requestFocus(FocusNode());

    var map = new Map<String, String>();
    map['mobile'] = mobile;
    map['otp'] = "1111";

    CallApi().post(context, BaseURL.VERIFY_MOBILE_URL, map, true).then((value) {
      Map jsonMap = json.decode(value);
      sharedPrefs.setString("student_list", json.encode(jsonMap).toString());
      /*final List studentList = responseData[BaseURL.DATA];
          List<StudentModel> list =
              studentList.map((val) => StudentModel.fromJson(val)).toList();
*/
      print("responseData:" + sharedPrefs.getString("student_list"));

      final List studentList =
          json.decode(sharedPrefs.getString("student_list"));
      _studentList.addAll(
          studentList.map((val) => StudentModel.fromJson(val)).toList());

      _bottomSheetStudentList(context);
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  _storeSession(Map data) async {
    // set value
    sharedPrefs.setString(BaseURL.KEY_USER_ID, data["parent_id"].toString());
    sharedPrefs.setString(
        BaseURL.KEY_USER_NAME, data["parent_fullname"].toString());
    sharedPrefs.setString("studentData", jsonEncode(data).toString());
    sharedPrefs.setInt(BaseURL.KEY_LOGIN_TYPE, 2);
    sharedPrefs.setBool(BaseURL.KEY_IS_LOGIN, true);

    print(sharedPrefs.getString(BaseURL.KEY_USER_ID));

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

  bool isDialogShowing = false;

  void _showLoading() {
    if (_loading) {
      isDialogShowing = true;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new CustomLoader();
          });
    } else {
      if (isDialogShowing) {
        Navigator.of(context).pop();
      }
      isDialogShowing = false;
    }
  }

  _displaySnackBar(BuildContext context, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
