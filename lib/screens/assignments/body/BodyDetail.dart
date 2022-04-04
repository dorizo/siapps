import 'package:classes_app/models/HomeMenuModel.dart';
import 'package:classes_app/screens/assignments/WebviewLink.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:classes_app/models/AssignmentModel.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/DateFormatter.dart';

class BodyDetail extends StatelessWidget {
  BodyDetail(
      {Key key,
      this.assignmentModel,
      this.downloadClick,
      this.submitClick,
      this.viewClick})
      : super(key: key);

  final AssignmentModel assignmentModel;

  final VoidCallback viewClick;
  final VoidCallback downloadClick;
  final VoidCallback submitClick;

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Expanded(
          child: new ListView(
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              new Text(
                assignmentModel.assign_title ?? "",
                style: TextStyle(
                    fontFamily: "bold",
                    color: ColorsInt.colorText,
                    fontSize: 16.0),
              ),
              new Text(
                assignmentModel.batch_name ?? "",
                style: TextStyle(
                  fontFamily: "bold",
                  color: ColorsInt.colorText,
                ),
              ),
              new SizedBox(
                height: 10.0,
              ),
              new Divider(
                height: 1.0,
                color: ColorsInt.colorDivider,
              ),
              new SizedBox(
                height: 10.0,
              ),
              new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Visibility(
                    visible: (assignmentModel.submitted_date != null &&
                        assignmentModel.submitted_date.isNotEmpty),
                    child: new ImageIcon(
                      AssetImage("assets/images/ic_doc.png"),
                      size: 15.0,
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: new Text(
                        "${(assignmentModel.submitted_date != null && assignmentModel.submitted_date.isNotEmpty) ? AppLocalizations.of(context).translate("submitted_on") : AppLocalizations.of(context).translate("submit_till_date")} ${(assignmentModel.submitted_date != null && assignmentModel.submitted_date.isNotEmpty) ? DateFormatter.getConvetedDate(assignmentModel.submitted_date ?? "", 3) : assignmentModel.assign_end_of_submission_date}",
                        style: TextStyle(
                            color: (assignmentModel.submitted_date != null &&
                                    assignmentModel.submitted_date.isNotEmpty)
                                ? ColorsInt.colorText
                                : ColorsInt.colorRed,
                            fontSize: 10.0,
                            fontFamily: "regular"),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              new Visibility(
                visible: ((assignmentModel.grade ?? "").isNotEmpty ||
                    (assignmentModel.note ?? "").isNotEmpty),
                child: new Container(
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: ColorsInt.colorPrimary, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Visibility(
                        visible: (assignmentModel.grade ?? "").isNotEmpty,
                        child: new Text(
                          "${AppLocalizations.of(context).translate("grad")} ${assignmentModel.grade ?? ""}",
                          style: TextStyle(
                              color: ColorsInt.colorText,
                              fontSize: 10.0,
                              fontFamily: "regular"),
                        ),
                      ),
                      new Visibility(
                        visible: (assignmentModel.note ?? "").isNotEmpty,
                        child: new Text(
                          "${AppLocalizations.of(context).translate("note")} ${assignmentModel.note ?? ""}",
                          style: TextStyle(
                              color: ColorsInt.colorText,
                              fontSize: 10.0,
                              fontFamily: "regular"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new Html(
                data: """${assignmentModel.assign_description ?? ""}""",
                shrinkToFit: false,
                defaultTextStyle: TextStyle(
                    fontFamily: "regular", color: ColorsInt.colorTextHint),
                      onLinkTap: (url) {
                  print(url);
                  Navigator.pushNamed(context, '/webviewlink',
                  arguments: HomeMenuModel(
                    'Detail '+assignmentModel.note,
                    url,
                  ));
                },
              ),
            ],
          ),
        ),
        new InkWell(
          child: new Visibility(
              child: new Padding(
            padding: EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
            child: new Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: ColorsInt.colorPrimary,
                    borderRadius: BorderRadius.all(Radius.circular(180.0))),
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(right: 10.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new ImageIcon(
                      AssetImage("assets/images/ic_view.png"),
                      size: 20.0,
                      color: ColorsInt.colorWhite,
                    ),
                    new Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: new Center(
                        child: new Text(
                          AppLocalizations.of(context).translate("view"),
                          style: TextStyle(
                              color: ColorsInt.colorWhite,
                              fontFamily: "regular"),
                        ),
                      ),
                    ),
                  ],
                )),
          )),
          onTap: () => viewClick(),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: new InkWell(
                  child: new Container(
                      decoration: BoxDecoration(
                          color: ColorsInt.colorPrimary,
                          borderRadius:
                              BorderRadius.all(Radius.circular(180.0))),
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(right: 10.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new ImageIcon(
                            AssetImage("assets/images/ic_doc.png"),
                            size: 15.0,
                            color: ColorsInt.colorWhite,
                          ),
                          new Container(
                            margin: EdgeInsets.only(left: 5.0),
                            child: new Center(
                              child: new Text(
                                AppLocalizations.of(context)
                                    .translate("download"),
                                style: TextStyle(
                                    color: ColorsInt.colorWhite,
                                    fontFamily: "regular"),
                              ),
                            ),
                          ),
                        ],
                      )),
                  onTap: () => downloadClick(),
                ),
                flex: 1,
              ),
              new Expanded(
                child: new InkWell(
                  child: new Container(
                      decoration: BoxDecoration(
                          color: ColorsInt.colorPrimary,
                          borderRadius:
                              BorderRadius.all(Radius.circular(180.0))),
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(left: 10.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new ImageIcon(
                            AssetImage("assets/images/ic_submit.png"),
                            size: 15.0,
                            color: ColorsInt.colorWhite,
                          ),
                          new Container(
                            margin: EdgeInsets.only(left: 5.0),
                            child: new Center(
                              child: new Text(
                                (assignmentModel.submitted_date != null &&
                                        assignmentModel
                                            .submitted_date.isNotEmpty)
                                    ? AppLocalizations.of(context)
                                        .translate("re_submit")
                                    : AppLocalizations.of(context)
                                        .translate("submit"),
                                style: TextStyle(
                                    color: ColorsInt.colorWhite,
                                    fontFamily: "regular"),
                              ),
                            ),
                          ),
                        ],
                      )),
                  onTap: () => submitClick(),
                ),
                flex: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
