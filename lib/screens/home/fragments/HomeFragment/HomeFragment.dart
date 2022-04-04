import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:classes_app/screens/home/fragments/HomeFragment/Body.dart';

import 'package:classes_app/models/AnnouncementModel.dart';
import 'package:classes_app/models/StudentModel.dart';
import 'package:classes_app/models/HomeMenuModel.dart';
import 'package:classes_app/models/BatchModel.dart';
import 'package:classes_app/models/ClassRoomModel.dart';

import 'package:classes_app/components/CustomLoader.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/utils/CallApi.dart';
import 'package:classes_app/utils/app_localizations.dart';

class HomeFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeFragmentPage();
  }
}

class HomeFragmentPage extends StatefulWidget {
  HomeFragmentPage({Key key}) : super(key: key);

  @override
  _HomeFragmentPageState createState() => _HomeFragmentPageState();
}

class _HomeFragmentPageState extends State<HomeFragmentPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;
  SharedPreferences sharedPrefs;
  List<AnnouncementModel> _announcementModelList = [];
  List<BatchModel> _batchModelList = [];
  List<ClassRoomModel> _classRoomModelList = [];
  int _loginType = 1;
  StudentModel _studentModel = null;
  List<StudentModel> _studentList = [];

  List<HomeMenuModel> _homeMenuList = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _updateDetail();
    });

    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      _loginType = sharedPrefs.getInt(BaseURL.KEY_LOGIN_TYPE);
      _updateDetail();
    });
  }

  _updateMenu() {
    final homeMenuList = [
      HomeMenuModel("assets/images/ic_attendance.png",
          AppLocalizations.of(context).translate("attendance")),
      HomeMenuModel("assets/images/ic_courses.png",
          AppLocalizations.of(context).translate("batches")),
      HomeMenuModel("assets/images/ic_fees.png",
          AppLocalizations.of(context).translate("fees")),
      HomeMenuModel("assets/images/ic_exams.png",
          AppLocalizations.of(context).translate("exams")),
      HomeMenuModel("assets/images/ic_assigments.png",
          AppLocalizations.of(context).translate("assignments")),
      // HomeMenuModel("assets/images/ic_study_material.png",
      //     AppLocalizations.of(context).translate("study_material")),
      HomeMenuModel("assets/images/ic_classroom.png",
          AppLocalizations.of(context).translate("class_rooms")),
      HomeMenuModel("assets/images/ic_announcement.png",
          AppLocalizations.of(context).translate("announcement")),
      HomeMenuModel("assets/images/report.png",
          AppLocalizations.of(context).translate("Report")),
    ];
    setState(() {
      _homeMenuList.clear();
      _homeMenuList = homeMenuList;
    });
  }

  _updateDetail() {
    if (sharedPrefs.containsKey("studentData")) {
      var studentData = json.decode(sharedPrefs.getString("studentData"));
      _studentModel = StudentModel.fromJson(studentData);
    }

    if (sharedPrefs.containsKey("student_list")) {
      final List studentList =
          json.decode(sharedPrefs.getString("student_list"));
      _studentList.addAll(
          studentList.map((val) => StudentModel.fromJson(val)).toList());
    }

    makeGetTodayBatches(context);
    makeGetMaster(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMenu();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: new Body(
        homeMenuList: _getListData(),
        announcementModelList: _announcementModelList,
        homeModelList: _homeMenuList,
        batchModelList: _batchModelList,
        classRoomModelList: _classRoomModelList,
        loginType: _loginType,
        studentModel: _studentModel,
        onHomeMenuSelected: (String title) {
          _itemSelected(title);
        },
        myChildClick: () {
          if (sharedPrefs.containsKey("studentList")) {
            final List dataJson =
                json.decode(sharedPrefs.getString("studentList"));
            setState(() {
              _studentList.clear();
              _studentList.addAll(
                  dataJson.map((val) => StudentModel.fromJson(val)).toList());

              sharedPrefs.setString(
                  "studentList", json.encode(dataJson).toString());

              print(sharedPrefs.getString("studentList"));

              _bottomSheetStudentList(context);
            });
          }
        },
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

  makeGetTodayBatches(BuildContext context) {
    var url = BaseURL.GET_TODAY_BATCHES_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);

    CallApi().post(context, url, map, true).then((response) {
      final List dataJson = json.decode(response);
      sharedPrefs.setString("today_batches", response);

      setState(() {
        _batchModelList.clear();
        _batchModelList
            .addAll(dataJson.map((val) => BatchModel.fromJson(val)).toList());
        print("totalsize:" + _batchModelList.length.toString());
      });
      if (sharedPrefs.getInt(BaseURL.KEY_LOGIN_TYPE) != 3) {
        makeGetAnnouncement(context);
      }
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
      if (sharedPrefs.getInt(BaseURL.KEY_LOGIN_TYPE) != 3) {
        makeGetAnnouncement(context);
      }
    });
  }

  makeGetMaster(BuildContext context) {
    var url = BaseURL.GET_MASTER_LIST_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);

    CallApi().post(context, url, map, true).then((response) {
      final Map dataJson = json.decode(response);
      sharedPrefs.setString("batches_list", jsonEncode(dataJson["batches"]));
      sharedPrefs.setString("subject_list", jsonEncode(dataJson["subjects"]));

      if (dataJson.containsKey("onlineclassroom")) {
        List classroomList = dataJson["onlineclassroom"];
        setState(() {
          _classRoomModelList.clear();
          _classRoomModelList.addAll(classroomList
              .map((val) => ClassRoomModel.fromJson(val))
              .toList());
        });
      }
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
      if (sharedPrefs.getInt(BaseURL.KEY_LOGIN_TYPE) != 3) {
        makeGetAnnouncement(context);
      }
    });
  }

  _getListData() {
    List<Widget> widgets = [];
    for (int i = 0; i < _homeMenuList.length; i++) {
      var homeMenuModel = _homeMenuList[i];
      widgets.add(GestureDetector(
        child: new Padding(
          padding: EdgeInsets.all(5.0),
          child: new Container(
              width: double.infinity,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Image.asset(homeMenuModel.icon),
                  ),
                  new Text(
                    homeMenuModel.title,
                    style: TextStyle(
                        fontFamily: "regular", color: ColorsInt.colorText),
                  ),
                ],
              )),
        ),
        onTap: () {
          print('row tapped ${homeMenuModel.title}');
          _itemSelected(homeMenuModel.title);
        },
      ));
    }
    return widgets;
  }

  void _bottomSheetStudentList(context) {
    Future<void> future = showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState
                  /*You can rename this!*/) {
            //_setModalState = setModalState;
            return new ListView.builder(
                shrinkWrap: true,
                itemCount: _studentList.length,
                itemBuilder: (context, index) {
                  var studentModel = _studentList[index];

                  return new Column(children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50.0),
                              topLeft: Radius.circular(50.0))),
                      child: new ListTile(
                          leading: new Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorsInt.colorDivider,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(BaseURL.IMG_STUDENT +
                                    studentModel.stud_photo),
                              ),
                            ),
                          ),
                          title: new Text(studentModel.stud_first_name),
                          onTap: () => {_loadNewStudent(studentModel.toMap())}),
                    ),
                    new Divider(
                      color: ColorsInt.colorDivider,
                    )
                  ]);
                });
          });
        });
  }

  _loadNewStudent(Map data) {
    print("Student Click");
    sharedPrefs.setString(BaseURL.KEY_USER_ID, data["student_id"].toString());
    sharedPrefs.setString(
        BaseURL.KEY_USER_NAME, data["stud_first_name"].toString());
    sharedPrefs.setString(
        BaseURL.KEY_STATUS, data[BaseURL.KEY_STATUS].toString());
    sharedPrefs.setString(
        BaseURL.KEY_USER_TYPE, data[BaseURL.KEY_USER_TYPE].toString());
    sharedPrefs.setString(
        BaseURL.KEY_STUDENT_DETAIL, json.encode(data).toString());
    sharedPrefs.setString("studentData", json.encode(data).toString());

    Navigator.pop(context);

    _updateDetail();
  }

  bool isDialogShowing = false;

  void _showLoading() {
    if (_loading) {
      isDialogShowing = true;
      var loaderDialog = showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new CustomLoader();
          });
    } else {
      if (isDialogShowing) {
        Navigator.of(context).pop();
        isDialogShowing = false;
      }
    }
  }

  _itemSelected(String title) {
    if (title == AppLocalizations.of(context).translate("attendance")) {
      Navigator.of(context).pushNamed('/attendance');
    } else if (title == AppLocalizations.of(context).translate("batches")) {
      Navigator.of(context).pushNamed('/BatchesList');
    } else if (title == AppLocalizations.of(context).translate("fees")) {
      Navigator.of(context).pushNamed('/Fees');
    } else if (title == AppLocalizations.of(context).translate("exams")) {
     if(_loginType==1){
       Navigator.of(context).pushNamed('/Exams');
     }else{
      _displaySnackBar(context,"This access students only");
     }
    } else if (title == AppLocalizations.of(context).translate("assignments")) {
      if(_loginType==1){
         Navigator.of(context).pushNamed('/assignments');
       }else{
      _displaySnackBar(context,"This access students only");
     }
    } else if (title ==
        AppLocalizations.of(context).translate("study_material")) {
      Navigator.of(context).pushNamed('/study_material');
    } else if (title == AppLocalizations.of(context).translate("class_rooms")) {
      Navigator.of(context).pushNamed('/ClassRoom');
    } else if (title ==
        AppLocalizations.of(context).translate("announcement")) {
      Navigator.of(context).pushNamed('/Announcement');
    }else if (title ==
        AppLocalizations.of(context).translate("Report")) {
      Navigator.pushNamed(context, '/report',
                  arguments: HomeMenuModel(
                    'Report ',
                    'https://demo.siapps.id/admin/report/index/citm0029/'+sharedPrefs.getString(BaseURL.KEY_USER_ID),
                  ));
 
    }
  }

  _displaySnackBar(BuildContext context, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _handleSendNotification() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;

    var imgUrlString =
        "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";

    var notification = OSCreateNotification(
        playerIds: [playerId],
        content: "this is a test from",
        heading: "Test title",
        iosAttachments: {"id1": imgUrlString},
        bigPicture: imgUrlString,
        androidSmallIcon: "assets/images/ic_fees.png",
        androidLargeIcon: "assets/images/ic_fees.png");

    /*var notification = OSCreateNotification(
        playerIds: [playerId],
        content: "this is a test from OneSignal's Flutter SDK",
        heading: "Test Notification",
        iosAttachments: {"id1": imgUrlString},
        bigPicture: imgUrlString,
        buttons: [
          OSActionButton(text: "test1", id: "id1"),
          OSActionButton(text: "test2", id: "id2")
        ]);*/

    var response = await OneSignal.shared.postNotification(notification);
    print("Sent notification with response: $response");
  }
}
