import 'package:flutter/material.dart';

import 'package:classes_app/models/ClassRoomModel.dart';

import 'package:classes_app/screens/classroom/ClassRoomDetail.dart';

import 'package:classes_app/components/TextRegular.dart';
import 'package:classes_app/components/TextBold.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/DateFormatter.dart';

class Body extends StatelessWidget {
  Body({Key key, this.classRoomModelList}) : super(key: key);

  List<ClassRoomModel> classRoomModelList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: classRoomModelList.length,
        physics: ClampingScrollPhysics(),
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
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              elevation: 0.0,
              child: new InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClassRoomDetail(
                                classRoomModel: classRoomModel,
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
                                      BorderRadius.all(Radius.circular(8.0))),
                              color: ColorsInt.colorTextHint,
                              child: new ImageIcon(AssetImage(thumbIcon)),
                            ),
                          )),
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new TextBold(
                                title:
                                    "${DateFormatter.getConvetedTime(context,classRoomModel.meeting_time, 1)}",
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
                                title: classRoomModel.batches ?? "",
                                size: 12.0,
                                color: ColorsInt.colorTextHint,
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
        });
  }
}
