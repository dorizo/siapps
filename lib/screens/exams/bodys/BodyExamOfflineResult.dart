import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:classes_app/models/ExamModel.dart';
import 'package:classes_app/models/ExamResultModel.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/DateFormatter.dart';
import 'package:classes_app/utils/app_localizations.dart';

class BodyExamOfflineResult extends StatelessWidget {
  BodyExamOfflineResult(
      {Key key,
      this.examModel,
      this.examResultModelList,
      this.totalMarks,
      this.totalObtain,
      this.totalPercentage})
      : super(key: key);

  ExamModel examModel;
  List<ExamResultModel> examResultModelList;
  double totalMarks;
  double totalObtain;
  double totalPercentage;

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          color: ColorsInt.colorPrimary,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                  child: new Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    DateFormatter.getConvetedDate(examModel.exam_date, 4),
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "regular",
                        color: ColorsInt.colorWhite),
                  )
                ],
              )),
              new Text(
                "${totalPercentage.toStringAsFixed(1)}%",
                style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "bold",
                    color: ColorsInt.colorWhite),
              ),
            ],
          ),
        ),
        new Container(
          padding: EdgeInsets.all(10.0),
          color: ColorsInt.colorGray,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Expanded(
                child: new Text(
                  AppLocalizations.of(context).translate("subject"),
                  style: TextStyle(
                      fontFamily: "regular", color: ColorsInt.colorText),
                ),
                flex: 5,
              ),
              new Expanded(
                child: new Text(
                  AppLocalizations.of(context)
                      .translate("marks")
                      .replaceAll(":", ""),
                  style: TextStyle(
                      fontFamily: "regular", color: ColorsInt.colorText),
                ),
                flex: 2,
              ),
              new Expanded(
                child: new Text(
                  AppLocalizations.of(context).translate("obtain"),
                  style: TextStyle(
                      fontFamily: "regular", color: ColorsInt.colorText),
                ),
                flex: 2,
              ),
            ],
          ),
        ),
        new ListView.builder(
            shrinkWrap: true,
            itemCount: examResultModelList.length,
            itemBuilder: (context, index) {
              final examResultModel = examResultModelList[index];

              return new Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.all(10.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(
                          child: new Text(
                            examResultModel.subject ?? "",
                            style: TextStyle(
                                fontFamily: "regular",
                                color: ColorsInt.colorText),
                          ),
                          flex: 5,
                        ),
                        new Expanded(
                          child: new Text(
                            examResultModel.total_marks ?? "",
                            style: TextStyle(
                                fontFamily: "regular",
                                color: ColorsInt.colorText),
                          ),
                          flex: 2,
                        ),
                        new Expanded(
                          child: new Text(
                            examResultModel.obtain_marks ?? "",
                            style: TextStyle(
                                fontFamily: "regular",
                                color: ColorsInt.colorText),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                  new Divider(
                    height: 1.0,
                    color: ColorsInt.colorDivider,
                  ),
                ],
              );
            }),
        new Container(
          padding: EdgeInsets.all(10.0),
          color: ColorsInt.colorGray,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Expanded(
                child: new Text(
                  AppLocalizations.of(context).translate("total_marks"),
                  style: TextStyle(
                      fontFamily: "bold", color: ColorsInt.colorBlack),
                ),
                flex: 5,
              ),
              new Expanded(
                child: new Text(
                  totalMarks.toStringAsFixed(1) ?? "",
                  style: TextStyle(
                      fontFamily: "bold", color: ColorsInt.colorBlack),
                ),
                flex: 2,
              ),
              new Expanded(
                child: new Text(
                  totalObtain.toStringAsFixed(1) ?? "",
                  style: TextStyle(
                      fontFamily: "bold", color: ColorsInt.colorBlack),
                ),
                flex: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
