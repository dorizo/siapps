import 'package:classes_app/config/BaseURL.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:classes_app/screens/classroom/body/BodyDetail.dart';

import 'package:classes_app/models/ClassRoomModel.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';

class ClassRoomDetail extends StatefulWidget {
  ClassRoomDetail({Key key, this.classRoomModel}) : super(key: key);

  final ClassRoomModel classRoomModel;


  @override
  _ClassRoomDetailState createState() => _ClassRoomDetailState();
}

class _ClassRoomDetailState extends State<ClassRoomDetail> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool result = false;
    SharedPreferences sharedPrefs;
  int _loginType = 1;

  @override
  void initState() {
    super.initState();
     SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      _loginType = sharedPrefs.getInt(BaseURL.KEY_LOGIN_TYPE);
    print(sharedPrefs.getInt(BaseURL.KEY_LOGIN_TYPE));
    });
  }

  _linkClick() {
    Clipboard.setData(new ClipboardData(text: widget.classRoomModel.link));
    final snackBar = SnackBar(
      content: Text('Link Copied'),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _joinNowClick() async {
    print(_loginType);
    if(_loginType==2){
    final snackBar = SnackBar(
      content: Text('this Access Only Student'),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
    }else{
     final callurl = "${widget.classRoomModel.link}";
    if (await canLaunch(callurl)) {
      await launch(callurl);
    } else {
      throw 'Could not launch $callurl';
    }
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("class_rooms")),
        backgroundColor: ColorsInt.colorPrimary,
      ),
      body: new BodyDetail(
        classRoomModel: widget.classRoomModel,
        linkClick: () => _linkClick(),
        joinNowClick: () => _joinNowClick(),
      ),
    );
  }
}
