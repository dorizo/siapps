import 'package:classes_app/utils/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:classes_app/models/BatchModel.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/DateFormatter.dart';
import 'package:flutter/rendering.dart';
import 'package:classes_app/config/globals.dart' as globles;

class Body extends StatelessWidget {
  Body({Key key, this.batchModelList}) : super(key: key);

  List<BatchModel> batchModelList;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        shrinkWrap: false,
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
                child: new Column(
                  children: <Widget>[
                    new Row(
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
                                batchModel.batch_name ?? "",
                                style: TextStyle(
                                  fontFamily: "regular",
                                  fontSize: 16.0,
                                  color: ColorsInt.colorBlack,
                                ),
                              ),
                              new Text(
                                batchModel.subject_name ?? "",
                                style: TextStyle(
                                  fontFamily: "regular",
                                  fontSize: 12.0,
                                  color: ColorsInt.colorBlack,
                                ),
                              ),
                              new Text(
                                batchModel.teacher_fullname ?? "",
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
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: new Text(
                                  "${DateFormatter.getConvetedTime(context, batchModel.start_time, 1)} - ${DateFormatter.getConvetedTime(context, batchModel.end_time, 1)}",
                                  style: TextStyle(
                                    fontFamily: "bold",
                                    fontSize: 14.0,
                                    color: ColorsInt.colorBlack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    new SizedBox(
                      height: 5.0,
                    ),
                    new SizedBox(
                      height: 35.0,
                      child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: 7,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index1) {
                            bool hasDay = false;
                            if (batchModel.days != null &&
                                batchModel.days.isNotEmpty) {
                              final days = batchModel.days.split(",");
                              if (index1 == 0 && days.contains("Sun")) {
                                hasDay = true;
                              } else if (index1 == 1 && days.contains("Mon")) {
                                hasDay = true;
                              } else if (index1 == 2 && days.contains("Tue")) {
                                hasDay = true;
                              } else if (index1 == 3 && days.contains("Wed")) {
                                hasDay = true;
                              } else if (index1 == 4 && days.contains("Thu")) {
                                hasDay = true;
                              } else if (index1 == 5 && days.contains("Fri")) {
                                hasDay = true;
                              } else if (index1 == 6 && days.contains("Sat")) {
                                hasDay = true;
                              } else {
                                hasDay = false;
                              }
                            }
                            return new Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (hasDay)
                                    ? ColorsInt.colorGreen
                                    : ColorsInt.colorWhite,
                                border: Border.all(
                                  color: ColorsInt.colorGray,
                                  width: 1.0,
                                ),
                              ),
                              padding: EdgeInsets.all(5.0),
                              margin: EdgeInsets.only(left: 2.0),
                              height: 30.0,
                              width: 30.0,
                              child: new Center(
                                child: new FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: new Text(
                                    AppLocalizations.of(context)
                                        .translate("seven_day")
                                        .split(",")[index1],
                                    style: TextStyle(
                                      fontFamily: "bold",
                                      fontSize: 12.0,
                                      color: (hasDay)
                                          ? ColorsInt.colorWhite
                                          : ColorsInt.colorText,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
