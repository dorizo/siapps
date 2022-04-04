import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:classes_app/models/ClassRoomModel.dart';

import 'package:classes_app/components/TextRegular.dart';
import 'package:classes_app/components/TextBold.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/DateFormatter.dart';

class BodyDetail extends StatelessWidget {
  BodyDetail({Key key, this.classRoomModel, this.linkClick, this.joinNowClick})
      : super(key: key);

  final ClassRoomModel classRoomModel;

  final VoidCallback joinNowClick;
  final VoidCallback linkClick;

  @override
  Widget build(BuildContext context) {
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

    return new Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Expanded(
          child: new Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Center(
                      child: new Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorsInt.colorTextHint,
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: new Image.asset(
                          thumbIcon,
                          height: 50.0,
                          width: 50.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 20.0,
                    ),
                    new InkWell(
                      child: new TextRegular(
                        title: classRoomModel.link ?? "",
                        size: 16.0,
                      ),
                      onTap: () => linkClick(),
                    ),
                    new TextBold(
                      title:
                          "${AppLocalizations.of(context).translate("start_at")} ${DateFormatter.getConvetedDateTime(context, "${classRoomModel.meeting_date} ${classRoomModel.meeting_time}", 1)}",
                      size: 16.0,
                      color: ColorsInt.colorText,
                    ),
                    new TextRegular(
                      title: classRoomModel.batches ?? "",
                      size: 14.0,
                      color: ColorsInt.colorTextHint,
                    ),
                    new Visibility(
                      visible: (classRoomModel.password != null &&
                          classRoomModel.password.isNotEmpty),
                      child: new TextRegular(
                        title:
                            "${AppLocalizations.of(context).translate("password")}: ${classRoomModel.password}",
                        size: 14.0,
                        color: ColorsInt.colorText,
                      ),
                    ),
                  ],
                ),
              ),
              new Html(
                data: """${classRoomModel.description ?? ""}""",
                shrinkToFit: true,
                defaultTextStyle: TextStyle(
                    fontFamily: "regular", color: ColorsInt.colorText),
              ),
            ],
          ),
        ),
        new Visibility(
          visible: (DateFormatter.isDateValid(classRoomModel.meeting_date) &&
              DateFormatter.isTimeValidClasses(
                  classRoomModel.meeting_time, 15)),
          child: new Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: new InkWell(
              child: new Container(
                decoration: BoxDecoration(
                    color: ColorsInt.colorPrimary,
                    borderRadius: BorderRadius.all(Radius.circular(180.0))),
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(left: 10.0),
                child: new Center(
                  child: new TextRegular(
                    title: AppLocalizations.of(context).translate("join_now"),
                    size: 18.0,
                    color: ColorsInt.colorWhite,
                  ),
                ),
              ),
              onTap: () => joinNowClick(),
            ),
          ),
        ),
      ],
    );
  }
}
