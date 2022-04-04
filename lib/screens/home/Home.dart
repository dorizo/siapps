import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

import 'package:classes_app/screens/home/fragments/HomeFragment/HomeFragment.dart';
import 'package:classes_app/screens/home/fragments/AboutFragment/About.dart';
import 'package:classes_app/screens/home/fragments/TeacherFragment/Teachers.dart';
import 'package:classes_app/screens/login/Login.dart';
import 'package:classes_app/screens/home/dialog/ChooseLanguageDialog.dart';

import 'package:classes_app/models/StudentModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/AppLanguage.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  runApp(Home());
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;
  int _selectedDrawerIndex = 0;

  final drawerItems = [];

  StudentModel _studentModel = null;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _updateMenu();
    });

    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);

      if (sharedPrefs.containsKey("studentData")) {
        var studentData = json.decode(sharedPrefs.getString("studentData"));
        _studentModel = StudentModel.fromJson(studentData);
      }
    });
  }

  _updateMenu() {
    setState(() {
      drawerItems.clear();
      drawerItems.add(DrawerItem(
          AppLocalizations.of(context).translate("home"), Icons.home));
      drawerItems.add(DrawerItem(
          AppLocalizations.of(context).translate("about_us"),
          Icons.info_outline));
      drawerItems.add(DrawerItem(
          AppLocalizations.of(context).translate("teachers"), Icons.school));
      drawerItems.add(DrawerItem(
          AppLocalizations.of(context).translate("change_language"),
          Icons.language));
      drawerItems.add(DrawerItem(
          AppLocalizations.of(context).translate("logout"),
          Icons.power_settings_new));
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedDrawerIndex == 0) {
      //SystemNavigator.pop();
      //exit(0);
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return false;
    } else {
      setState(() => _selectedDrawerIndex = 0);
      return false;
    }
  }

  _getDrawerItemWidget(int pos) {
    //print("getDrawerItemWidget: $pos");
    switch (pos) {
      case 0:
        return new HomeFragment();
      case 1:
        return new About();
      case 2:
        return new Teachers();
      case 4:
        sharedPrefs.clear().then((onValue) {
          Route route = MaterialPageRoute(builder: (context) => Login());
          Navigator.pushReplacement(context, route);
        });
        return null;
        break;
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    Navigator.pop(context);
    if (index == 3) {
      _showChooseLanguage(context);
    } else {
      setState(() => _selectedDrawerIndex = index);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMenu();
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(
          d.title,
          style: TextStyle(
            fontFamily: "regular",
            color: (i == _selectedDrawerIndex)
                ? ColorsInt.colorPrimary
                : ColorsInt.colorText,
          ),
        ),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorsInt.colorPrimary));

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(
            (_selectedDrawerIndex == 0)
                ? AppLocalizations.of(context).translate("app_name")
                : drawerItems[_selectedDrawerIndex].title,
            style:
                TextStyle(fontFamily: "regular", color: ColorsInt.colorWhite),
          ),
          elevation: 0.0,
          backgroundColor: ColorsInt.colorPrimary,
          leading: new Builder(builder: (BuildContext context) {
            return new IconButton(
                icon: new Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                });
          }),
          actions: <Widget>[
            new InkWell(
              child: new Stack(
                children: <Widget>[
                  new Align(
                    child: new IconButton(
                      icon: Image.asset("assets/images/ic_notification.png"),
                      onPressed: null,
                    ),
                  ),
                  new Positioned(
                    top: 15.0,
                    right: 10.0,
                    child: new Container(
                      height: 10.0,
                      width: 10.0,
                      decoration: new BoxDecoration(
                        color: ColorsInt.colorRed2,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/Announcement');
              },
            ),
          ],
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
                    decoration: new BoxDecoration(
                        color: ColorsInt.colorPrimary,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0))),
                    child: new Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new CircleAvatar(
                          radius: 45.0,
                          backgroundColor: ColorsInt.colorBG,
                          backgroundImage: NetworkImage((_studentModel != null)
                              ? "${BaseURL.IMG_STUDENT}${_studentModel.stud_photo}"
                              : BaseURL.IMG_STUDENT),
                        ),
                        new SizedBox(
                          height: 5.0,
                        ),
                        new Text(
                          (_studentModel != null)
                              ? "${_studentModel.stud_first_name} ${_studentModel.stud_last_name}"
                              : "",
                          style: TextStyle(
                              color: ColorsInt.colorWhite,
                              fontSize: 18.0,
                              fontFamily: "regular"),
                        ),
                        new Text(
                          (_studentModel != null)
                              ? _studentModel.stud_contact ?? ""
                              : "",
                          style: TextStyle(
                              color: ColorsInt.colorWhite,
                              fontSize: 16.0,
                              fontFamily: "regular"),
                        ),
                      ],
                    ),
                  ),
                  new Column(children: drawerOptions)
                ],
              ),
            ],
          ),
        ),
        body: _getDrawerItemWidget(_selectedDrawerIndex),
      ),
    );
  }

  _showChooseLanguage(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new ChooseLanguageDialog(
          onEnglishClick: () {
            Provider.of<AppLanguage>(context, listen: false)
                .changeLanguage(Locale("en"));
            Navigator.pop(context);
          },
          onArabicClick: () {
            Provider.of<AppLanguage>(context, listen: false)
                .changeLanguage(Locale("ar"));
            Navigator.pop(context);
          },
          onFrenchClick: () {
            Provider.of<AppLanguage>(context, listen: false)
                .changeLanguage(Locale("fr"));
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
