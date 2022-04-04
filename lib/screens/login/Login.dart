import 'package:flutter/material.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:flutter/services.dart';
import 'package:classes_app/config/BaseURL.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:classes_app/screens/login/Body.dart';
import 'package:classes_app/screens/home/Home.dart';
import 'package:classes_app/components/CustomLoader.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'dart:convert';
import 'package:classes_app/utils/CallApi.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  bool _loading = false;

  final _username = TextEditingController();
  final _password = TextEditingController();

  bool _student = true;
  bool _teacher = false;
  bool _usernameError = false;
  bool _passwordError = false;

  String _userErrorMessage = "";
  String _passwordErrorMessage = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      _goNext();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorsInt.colorPrimary));
    return new Scaffold(
      key: _scaffoldKey,
      appBar: null,
      body: new Body(
        username: _username,
        password: _password,
        userErrorMessage: _userErrorMessage,
        usernameError: _usernameError,
        passwordErrorMessage: _passwordErrorMessage,
        passwordError: _passwordError,
        student: _student,
        teacher: _teacher,
        radioStudentClick: () {
          setState(() {
            _student = true;
            _teacher = false;
          });
        },
        radioTeacherClick: () {
          setState(() {
            _student = false;
            _teacher = true;
          });
        },
        parentLoginClick: () {
          Navigator.of(context).pushNamed('/parent_login');
        },
        checkLogin: () {
          _checkLogin(context);
        },
      ),
    );
  }

  _checkLogin(BuildContext context) {
    print("Coba Cek login");

    setState(() {
      _usernameError = false;
      _passwordError = false;
    });

    var cancel = false;

    var username = _username.text.toString();
    var password = _password.text.toString();

    if (username == "") {
      cancel = true;
      setState(() {
        _usernameError = true;
        _userErrorMessage =
            AppLocalizations.of(context).translate("error_required");
      });
    }
    if (password == "") {
      cancel = true;
      setState(() {
        _passwordError = true;
        _passwordErrorMessage =
            AppLocalizations.of(context).translate("error_required");
      });
    } else if (password.length < 4) {
      cancel = true;
      setState(() {
        _passwordError = true;
        _passwordErrorMessage =
            AppLocalizations.of(context).translate("error_password");
      });
    }

    if (!cancel) {
      //Navigator.of(context).pushNamed('/parent_login');
      makeLogin(context, username, password);
    }
  }

  //display snackbar
  _displaySnackBar(BuildContext context, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  //call login api and handle response
  Future<dynamic> makeLogin(
      BuildContext context, String username, String password) async {
    FocusScope.of(context).requestFocus(FocusNode());

    var map = new Map<String, String>();
    map['username'] = username;
    map['password'] = password;

    CallApi().post(context, BaseURL.LOGIN_URL, map, true).then((value) {
      Map data = json.decode(value);
      if (data[BaseURL.KEY_USER_TYPE] == "3") {
        sharedPrefs.setString(
            BaseURL.KEY_USER_ID, data[BaseURL.KEY_USER_ID].toString());
        sharedPrefs.setString(
            BaseURL.KEY_USER_NAME, data[BaseURL.KEY_USER_NAME].toString());
        sharedPrefs.setString(
            BaseURL.KEY_STATUS, data[BaseURL.KEY_STATUS].toString());
        sharedPrefs.setString(
            BaseURL.KEY_USER_TYPE, data[BaseURL.KEY_USER_TYPE].toString());
        sharedPrefs.setString(
            "teacherData", json.encode(data["teacherDetails"]).toString());
        sharedPrefs.setString("Teacher_url", data["redirectUrl"]);
        sharedPrefs.setInt(BaseURL.KEY_LOGIN_TYPE, 3);
        sharedPrefs.setBool(BaseURL.KEY_IS_LOGIN, true);
        Navigator.of(context).pushReplacementNamed('/Teacher');
      } else if (data[BaseURL.KEY_USER_TYPE] == "6") {
        _storeSession(data);
      }
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  bool isDialogShowing = false;

  //show loader
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

  //store session data
  _storeSession(Map data) async {
    // set value
    sharedPrefs.setString(
        BaseURL.KEY_USER_ID, data[BaseURL.KEY_USER_ID].toString());
    sharedPrefs.setString(
        BaseURL.KEY_USER_NAME, data[BaseURL.KEY_USER_NAME].toString());
    sharedPrefs.setString(
        BaseURL.KEY_STATUS, data[BaseURL.KEY_STATUS].toString());
    sharedPrefs.setString(
        BaseURL.KEY_USER_TYPE, data[BaseURL.KEY_USER_TYPE].toString());
    sharedPrefs.setString(BaseURL.KEY_STUDENT_DETAIL,
        data[BaseURL.KEY_STUDENT_DETAIL].toString());
    sharedPrefs.setString(
        BaseURL.KEY_BATCHES, data[BaseURL.KEY_BATCHES].toString());
    sharedPrefs.setString(
        BaseURL.KEY_PARENTS, data[BaseURL.KEY_PARENTS].toString());
    sharedPrefs.setInt(BaseURL.KEY_LOGIN_TYPE, 1);
    sharedPrefs.setBool(BaseURL.KEY_IS_LOGIN, true);

    sharedPrefs.setString("studentData",
        json.encode(data[BaseURL.KEY_STUDENT_DETAIL]).toString());

    print(sharedPrefs.getString(BaseURL.KEY_USER_ID));

    _goNext();
  }

  _goNext() async {
    if (sharedPrefs != null &&
        sharedPrefs.containsKey(BaseURL.KEY_IS_LOGIN) &&
        sharedPrefs.getBool(BaseURL.KEY_IS_LOGIN)) {
      //Navigator.of(context).pushNamed('/home');

      Route route = MaterialPageRoute(builder: (context) => Home());
      Navigator.pushReplacement(context, route);
    }
  }
}
