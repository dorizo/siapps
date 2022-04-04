import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:classes_app/models/StudentModel.dart';
import 'package:classes_app/models/ParentModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';

class Body extends StatelessWidget {
  Body(
      {Key key,
      this.studentModel,
      this.parentModelList,
      this.totalAttended,
      this.totalLeave,
      this.callClick})
      : super(key: key);

  final StudentModel studentModel;
  List<ParentModel> parentModelList;
  String totalAttended;
  String totalLeave;

  VoidCallback callClick;

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Stack(
          children: <Widget>[
            new Container(
              width: double.infinity,
              height: 70.0,
              padding: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
              margin: EdgeInsets.only(bottom: 30.0),
              decoration: BoxDecoration(
                  color: ColorsInt.colorPrimary,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0))),
              child: null,
            ),
            new Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: new Center(
                  child: new Hero(
                    tag: "studentphoto",
                    child: new CircleAvatar(
                      radius: 50.0,
                      backgroundImage: new NetworkImage(
                          "${BaseURL.IMG_STUDENT}${(studentModel != null) ? studentModel.stud_photo : ""}"),
                      backgroundColor: ColorsInt.colorGray,
                    ),
                  ),
                )),
            new Positioned(
                right: 50,
                bottom: 8,
                child: new InkWell(
                  child: new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(180.0),
                    ),
                    color: ColorsInt.colorGreen1,
                    child: new Padding(
                      padding: EdgeInsets.all(5.0),
                      child: new Image.asset(
                        "assets/images/ic_call_white.png",
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                  ),
                  onTap: () => callClick(),
                )),
          ],
        ),
        new SizedBox(
          height: 10.0,
        ),
        new Center(
          child: new Text(
            (studentModel != null) ? studentModel.stud_first_name ?? "" : "",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "bold",
              color: ColorsInt.colorBlack,
            ),
          ),
        ),
        new Center(
          child: new Text(
            (studentModel != null) ? studentModel.stud_id_card_no ?? "" : "",
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: "regular",
              color: ColorsInt.colorBlack,
            ),
          ),
        ),
        new SizedBox(
          height: 20.0,
        ),
        new Center(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: ColorsInt.colorGreen1),
                    padding: EdgeInsets.all(10.0),
                    child: new Center(
                      child: new Text(
                        totalAttended,
                        style: TextStyle(
                          fontFamily: "bold",
                          fontSize: 20.0,
                          color: ColorsInt.colorWhite,
                        ),
                      ),
                    ),
                  ),
                  new Text(
                    AppLocalizations.of(context).translate("present"),
                    style: TextStyle(
                      fontFamily: "regular",
                      color: ColorsInt.colorText,
                      fontSize: 16.0,
                    ),
                  )
                ],
              ),
              new SizedBox(
                width: 20.0,
              ),
              new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: ColorsInt.colorRed),
                    padding: EdgeInsets.all(10.0),
                    child: new Center(
                      child: new Text(
                        totalLeave,
                        style: TextStyle(
                          fontFamily: "bold",
                          fontSize: 20.0,
                          color: ColorsInt.colorWhite,
                        ),
                      ),
                    ),
                  ),
                  new Text(
                    AppLocalizations.of(context).translate("absent"),
                    style: TextStyle(
                      fontFamily: "regular",
                      color: ColorsInt.colorText,
                      fontSize: 16.0,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        new SizedBox(
          height: 30.0,
        ),
        new Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                AppLocalizations.of(context).translate("address"),
                style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 14.0,
                    color: ColorsInt.colorText),
              ),
              new Text(
                (studentModel != null) ? studentModel.stud_address ?? "" : "",
                style: TextStyle(
                    fontFamily: "regular",
                    fontSize: 14.0,
                    color: ColorsInt.colorTextHint),
              ),
              new SizedBox(
                height: 20.0,
              ),
              new Text(
                AppLocalizations.of(context).translate("mobile"),
                style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 14.0,
                    color: ColorsInt.colorText),
              ),
              new Text(
                (studentModel != null) ? studentModel.stud_contact ?? "" : "",
                style: TextStyle(
                    fontFamily: "regular",
                    fontSize: 14.0,
                    color: ColorsInt.colorTextHint),
              ),
              new SizedBox(
                height: 20.0,
              ),
              new Text(
                AppLocalizations.of(context).translate("parent_guardians"),
                style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 14.0,
                    color: ColorsInt.colorText),
              ),
            ],
          ),
        ),
        new ListView.builder(
            shrinkWrap: true,
            itemCount: parentModelList.length,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              final parentModel = parentModelList[index];

              return new InkWell(
                child: new Container(
                  margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorsInt.colorGray,
                      width: 1.0,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: ColorsInt.colorGray,
                        blurRadius: 1.0,
                        offset: new Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: new Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new CircleAvatar(
                          radius: 20.0,
                          backgroundImage: new NetworkImage(
                              "${BaseURL.IMG_PARENT + parentModel.parent_photo}"),
                          backgroundColor: ColorsInt.colorGray,
                        ),
                        new SizedBox(
                          width: 10.0,
                        ),
                        new Expanded(
                          child: new Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                parentModel.parent_fullname ?? "",
                                style: TextStyle(
                                  fontFamily: "regular",
                                  fontSize: 16.0,
                                  color: ColorsInt.colorBlack,
                                ),
                              ),
                              new Text(
                                parentModel.parent_type ?? "",
                                style: TextStyle(
                                  fontFamily: "regular",
                                  fontSize: 12.0,
                                  color: ColorsInt.colorBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {},
              );
            }),
        new SizedBox(
          height: 50.0,
        ),
      ],
    );
  }
}
