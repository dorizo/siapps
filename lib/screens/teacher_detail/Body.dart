import 'package:flutter/material.dart';

import 'package:classes_app/models/TeacherModel.dart';
import 'package:classes_app/models/BatchModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/DateFormatter.dart';

class Body extends StatelessWidget {
  Body({Key key, this.teacherModel, this.batchModelList, this.onCallClick})
      : super(key: key);

  TeacherModel teacherModel;
  List<BatchModel> batchModelList;

  VoidCallback onCallClick;

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.max,
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
                      tag: "teacher_${teacherModel.teacher_id}",
                      child: new CircleAvatar(
                        radius: 50.0,
                        backgroundImage: new NetworkImage(
                            "${BaseURL.IMG_TEACHER}${(teacherModel != null) ? teacherModel.teacher_photo : ""}"),
                        backgroundColor: ColorsInt.colorGray,
                      )),
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
                  onTap: () => onCallClick(),
                )),
          ],
        ),
        new SizedBox(
          height: 10.0,
        ),
        new Text(
          teacherModel.teacher_fullname ?? "",
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: "bold",
            color: ColorsInt.colorBlack,
          ),
        ),
        new Text(
          teacherModel.teacher_qualification ?? "",
          style: TextStyle(
            fontSize: 14.0,
            fontFamily: "regular",
            color: ColorsInt.colorBlack,
          ),
        ),
        new Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: new Text(
            AppLocalizations.of(context).translate("batches"),
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "bold",
              color: ColorsInt.colorBlack,
            ),
          ),
        ),
        new ListView.builder(
            shrinkWrap: true,
            itemCount: batchModelList.length,
            itemBuilder: (context, index) {
              final batchModel = batchModelList[index];
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
                      Radius.circular(15.0),
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
                        new Expanded(
                          child: new Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                batchModel.subject_name ?? "",
                                style: TextStyle(
                                  fontFamily: "regular",
                                  fontSize: 16.0,
                                  color: ColorsInt.colorBlack,
                                ),
                              ),
                              new Text(
                                batchModel.batch_name ?? "",
                                style: TextStyle(
                                  fontFamily: "regular",
                                  fontSize: 12.0,
                                  color: ColorsInt.colorBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                DateFormatter.getConvetedTime(
                                        context, batchModel.start_time, 1) ??
                                    "",
                                style: TextStyle(
                                  fontFamily: "bold",
                                  fontSize: 16.0,
                                  color: ColorsInt.colorBlack,
                                ),
                              ),
                              new Text(
                                batchModel.days ?? "",
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
              );
            }),
      ],
    );
  }
}
