import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:classes_app/screens/student_detail/StudentDetail.dart';
import 'package:classes_app/screens/classroom/ClassRoomDetail.dart';

import 'package:classes_app/models/HomeMenuModel.dart';
import 'package:classes_app/models/AnnouncementModel.dart';
import 'package:classes_app/models/BatchModel.dart';
import 'package:classes_app/models/StudentModel.dart';
import 'package:classes_app/models/ClassRoomModel.dart';

import 'package:classes_app/components/TextRegular.dart';
import 'package:classes_app/components/TextBold.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/theme/style.dart';
import 'package:classes_app/utils/DateFormatter.dart';
import 'package:classes_app/utils/app_localizations.dart';

class Body extends StatelessWidget {
  Body(
      {Key key,
      this.homeMenuList,
      this.announcementModelList,
      this.homeModelList,
      this.batchModelList,
      this.classRoomModelList,
      this.loginType,
      this.studentModel,
      @required this.onHomeMenuSelected,
      this.myChildClick})
      : super(key: key);

  final List<Widget> homeMenuList;
  final List<AnnouncementModel> announcementModelList;
  final List<HomeMenuModel> homeModelList;
  final List<BatchModel> batchModelList;
  final List<ClassRoomModel> classRoomModelList;

  final Function(String) onHomeMenuSelected;
  final VoidCallback myChildClick;

  final int loginType;
  final StudentModel studentModel;

  @override
  Widget build(BuildContext context) {
    return new ScrollConfiguration(
      behavior: new ScrollBehavior()
        ..buildViewportChrome(context, null, AxisDirection.down),
      child: new ListView(
        shrinkWrap: false,
        physics: new ClampingScrollPhysics(),
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  new Positioned(
                      top: 0.0,
                      bottom: 80.0,
                      left: 0.0,
                      right: 0.0,
                      child: new Container(
                        decoration: BoxDecoration(
                          color: ColorsInt.colorPrimary,
                          borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: null,
                      )),
                  new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Visibility(
                          visible: (loginType != 3),
                          child: (studentModel != null)
                              ? _getStudentHeader(context)
                              : new Container()),
                      (announcementModelList.length > 0)
                          ? _getSlider()
                          : new Container(
                              child: null,
                            ),
                    ],
                  )
                ],
              ),
              new Container(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: new GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: homeModelList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, position) {
                      var homeMenuModel = homeModelList[position];
                      return new GestureDetector(
                        child: new Container(
                            width: double.infinity,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  child: Image.asset(homeMenuModel.icon),
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: new Text(
                                    homeMenuModel.title,
                                    style: TextStyle(
                                        fontFamily: "regular",
                                        color: ColorsInt.colorText,
                                        fontSize: 12.0),
                                  ),
                                ),
                              ],
                            )),
                        onTap: () {
                          print('row tapped ${homeMenuModel.title}');
                          //_itemSelected(homeMenuModel.title);
                          onHomeMenuSelected(homeMenuModel.title);
                        },
                      );
                    },
                  )),
              new Visibility(
                  visible: (classRoomModelList.length > 0),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: new Text(
                          AppLocalizations.of(context)
                              .translate("upcoming_classroom"),
                          style: TextStyle(
                            color: ColorsInt.colorText,
                            fontFamily: "bold",
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      new ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: classRoomModelList.length,
                          itemBuilder: (context, index) {
                            var classRoomModel = classRoomModelList[index];

                            var thumbIcon = "assets/images/ic_youtube.png";
                            if (classRoomModel.type == "google_meet") {
                              thumbIcon = "assets/images/ic_google_meet.png";
                            } else if (classRoomModel.type == "zoom") {
                              thumbIcon = "assets/images/ic_zoom.png";
                            } else if (classRoomModel.type == "skype_meeting") {
                              thumbIcon = "assets/images/ic_skype.png";
                            } else if (classRoomModel.type == "youtube_live") {
                              thumbIcon = "assets/images/ic_youtube.png";
                            }

                            return new ListTile(
                              title: new Card(
                                margin: EdgeInsets.only(top: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                elevation: 0.0,
                                child: new InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClassRoomDetail(
                                                  classRoomModel:
                                                      classRoomModel,
                                                )));
                                  },
                                  child: new Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: new Row(
                                      children: <Widget>[
                                        new Visibility(
                                            visible: true,
                                            child: new Container(
                                              width: 60.0,
                                              height: 60.0,
                                              color: Colors.transparent,
                                              child: new Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0))),
                                                color: ColorsInt.colorTextHint,
                                                child: new ImageIcon(
                                                    AssetImage(thumbIcon)),
                                              ),
                                            )),
                                        new Expanded(
                                          child: new Container(
                                            margin: EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            child: new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new TextBold(
                                                  title:
                                                      "${DateFormatter.getConvetedTime(context, classRoomModel.meeting_time, 1)}",
                                                  size: 18.0,
                                                  color: ColorsInt.colorText,
                                                ),
                                                new TextBold(
                                                  title:
                                                      "${DateFormatter.getConvetedDate(classRoomModel.meeting_date, 4)}",
                                                  size: 14.0,
                                                  color: ColorsInt.colorText,
                                                ),
                                                new TextRegular(
                                                  title:
                                                      classRoomModel.batches ??
                                                          "",
                                                  size: 12.0,
                                                  color:
                                                      ColorsInt.colorTextHint,
                                                ),
                                              ],
                                            ),
                                          ),
                                          flex: 1,
                                        ),
                                        new Icon(
                                          Icons.arrow_forward_ios,
                                          color: ColorsInt.colorTextHint,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  )),
              new Container(
                margin: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                child: new Text(
                  AppLocalizations.of(context).translate("todays_baches"),
                  style: TextStyle(
                    color: ColorsInt.colorText,
                    fontFamily: "bold",
                    fontSize: 18.0,
                  ),
                ),
              ),
              new ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: batchModelList.length,
                  itemBuilder: (context, index) {
                    var batchModel = batchModelList[index];

                    var statusColor = ColorsInt.colorWhite;
                    var bgColor = ColorsInt.colorBachesBG1;
                    if (batchModel.attend_status == "absent") {
                      statusColor = ColorsInt.colorWhite;
                      bgColor = ColorsInt.colorBachesBG1;
                    } else if (batchModel.attend_status == "attended") {
                      statusColor = ColorsInt.colorBachesStatus2;
                      bgColor = ColorsInt.colorBachesBG2;
                    } else if (batchModel.attend_status == "leave") {
                      statusColor = ColorsInt.colorBachesStatus3;
                      bgColor = ColorsInt.colorBachesBG3;
                    }

                    return new ListTile(
                      title: new Card(
                        color: ColorsInt.colorWhite,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: new Stack(
                          children: <Widget>[
                            Positioned(
                              left: 0.1,
                              top: 0,
                              bottom: 0,
                              width: 8.0,
                              child: Container(
                                  decoration: new BoxDecoration(
                                color: bgColor,
                                borderRadius: new BorderRadius.only(
                                    topLeft: Radius.circular(11.0),
                                    bottomLeft: Radius.circular(11.0)),
                              )), // replace with your image
                            ),
                            new Container(
                              margin: EdgeInsets.only(left: 8.0),
                              padding: EdgeInsets.all(15.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Expanded(
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          batchModel.subject_name ?? "",
                                          style: TextStyle(
                                            color: ColorsInt.colorText,
                                            fontFamily: "bold",
                                          ),
                                        ),
                                        new Text(
                                          "By (${batchModel.teacher_fullname})",
                                          style: TextStyle(
                                            color: ColorsInt.colorDarkGreen,
                                            fontFamily: "regular",
                                          ),
                                        ),
                                      ],
                                    ),
                                    flex: 1,
                                  ),
                                  new Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    child: new Column(
                                      children: <Widget>[
                                        new Text(
                                          DateFormatter.getConvetedTime(context,
                                              batchModel.start_time ?? "", 1),
                                          style: TextStyle(
                                            color: ColorsInt.colorText,
                                            fontFamily: "bold",
                                          ),
                                        ),
                                        new Text(
                                          batchModel.attend_status ?? "",
                                          style: TextStyle(
                                            color: statusColor,
                                            fontFamily: "bold",
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
                      ),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getStudentHeader(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
      child: new InkWell(
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              color: Colors.transparent,
              child: new Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: ColorsInt.colorTextHint),
                child: new ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: new Hero(
                      tag: "studentphoto",
                      child: new Image.network(
                        "${BaseURL.IMG_STUDENT}${studentModel.stud_photo}",
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
            ),
            new Expanded(
              child: new Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Flexible(
                              child: new Text(
                            studentModel.stud_first_name ?? "",
                            style: TextStyle(
                              color: ColorsInt.colorWhite,
                              fontFamily: 'regular',
                            ),
                          )),
                          new Container(
                            margin: EdgeInsets.only(left: 5.0),
                            child: new ImageIcon(
                              AssetImage("assets/images/ic_edit.png"),
                              size: 15.0,
                              color: ColorsInt.colorWhite,
                            ),
                          )
                        ],
                      ),
                      new Text(
                        studentModel.stud_extra,
                        style: TextStyle(
                          color: ColorsInt.colorWhite,
                          fontFamily: 'regular',
                        ),
                      ),
                    ],
                  )),
              flex: 1,
            ),
            new Visibility(
              visible: (loginType == 2),
              child: new InkWell(
                child: new Container(
                  color: Colors.transparent,
                  child: new Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: ColorsInt.colorCyan),
                    child: new Text(
                      AppLocalizations.of(context).translate("my_child"),
                      style: TextStyle(
                        color: ColorsInt.colorWhite,
                        fontFamily: 'regular',
                      ),
                    ),
                  ),
                ),
                onTap: () => myChildClick(),
              ),
            ),
          ],
        ),
        onTap: () {
          //Navigator.of(context).pushNamed('/StudentDetail');
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 400),
                  pageBuilder: (_, __, ___) => StudentDetail(
                        studentModel: studentModel,
                      )));
        },
      ),
    );
  }

  Widget _getSlider() {
    return new Container(
      height: 100.0,
      child: new Swiper(
        itemCount: (announcementModelList.length >= 5)
            ? 5
            : announcementModelList.length,
        /*viewportFraction: 0.8,
        scale: 0.9,*/
        pagination: new SwiperPagination(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(top: 15.0),
          builder: const DotSwiperPaginationBuilder(
              activeColor: ColorsInt.colorGreen,
              color: ColorsInt.colorTextHint,
              size: 8.0,
              activeSize: 8.0),
        ),
        itemBuilder: (BuildContext context, int index) {
          var announcementModel = announcementModelList[index];

          return new Card(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 15.0, left: 20.0, right: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: new Container(
              child: new Container(
                padding: EdgeInsets.all(15.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      announcementModel.message ?? "",
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "regular",
                          color: ColorsInt.colorBlack),
                    ),
                    new Text(
                      DateFormatter.getConvetedDateTime(
                          context, announcementModel.created_at ?? "", 1),
                      style: TextStyle(
                          fontFamily: "regular",
                          fontSize: 10.0,
                          color: ColorsInt.colorCyan),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
