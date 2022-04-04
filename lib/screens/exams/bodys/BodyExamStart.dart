import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tex/flutter_tex.dart';

import 'package:classes_app/models/ExamModel.dart';
import 'package:classes_app/models/ExamQuestionModel.dart';
import 'package:classes_app/models/ExamQuestionOptionModel.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/DateFormatter.dart';

class BodyExamStart extends StatelessWidget {
  BodyExamStart(
      {Key key,
      this.examModel,
      this.examQuestionModelList,
      this.currentQuestionPosition,
      this.currentExamQuestionModel,
      this.seconds,
      this.answerClick,
      this.prevClick,
      this.nextClick,
      this.examFinished})
      : super(key: key);

  ExamModel examModel;
  List<ExamQuestionModel> examQuestionModelList;

  int seconds;

  int currentQuestionPosition;
  ExamQuestionModel currentExamQuestionModel;

  Function(ExamQuestionOptionModel) answerClick;
  VoidCallback examFinished;
  VoidCallback prevClick;
  VoidCallback nextClick;

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 20.0, left: 20.0, bottom: 20.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: new Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      (examModel != null) ? examModel.exam_title ?? "" : "",
                      style: TextStyle(
                        fontFamily: "regular",
                        fontSize: 12.0,
                        color: ColorsInt.colorBlack,
                      ),
                    ),
                    new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(
                          AppLocalizations.of(context)
                              .translate("time")
                              .toUpperCase(),
                          style: TextStyle(
                            fontFamily: "regular",
                            fontSize: 10.0,
                            color: ColorsInt.colorCyan,
                          ),
                        ),
                        new Text(
                          "${(examModel != null) ? examModel.exam_total_time ?? "" : ""} ${AppLocalizations.of(context).translate("min")}"
                              .toUpperCase(),
                          style: TextStyle(
                            fontFamily: "regular",
                            fontSize: 10.0,
                            color: ColorsInt.colorCyan,
                          ),
                        ),
                        new SizedBox(
                          width: 20.0,
                        ),
                        new Text(
                          AppLocalizations.of(context)
                              .translate("marks")
                              .toUpperCase(),
                          style: TextStyle(
                            fontFamily: "regular",
                            fontSize: 10.0,
                            color: ColorsInt.colorOrange,
                          ),
                        ),
                        new Text(
                          (examModel != null)
                              ? examModel.exam_total_marks ?? ""
                              : "",
                          style: TextStyle(
                            fontFamily: "regular",
                            fontSize: 10.0,
                            color: ColorsInt.colorOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              new Container(
                margin: EdgeInsets.only(left: 10.0),
                padding: EdgeInsets.only(
                    left: 15.0, top: 5.0, bottom: 5.0, right: 10.0),
                decoration: BoxDecoration(
                    color: ColorsInt.colorWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                    )),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      DateFormatter.formatHHMMSS(seconds),
                      style: TextStyle(
                        fontFamily: "regular",
                        fontSize: 14.0,
                        color: (seconds >= 30)
                            ? ColorsInt.colorBlack
                            : ColorsInt.colorRed,
                      ),
                    ),
                    new Text(
                      AppLocalizations.of(context).translate("min_left"),
                      style: TextStyle(
                        fontFamily: "regular",
                        fontSize: 14.0,
                        color: ColorsInt.colorBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: new Text(
            AppLocalizations.of(context)
                .translate("note_please_do_not_close_app_unit_exam_finish"),
            style: TextStyle(
              fontFamily: "regular",
              fontSize: 10.0,
              color: ColorsInt.colorRed,
            ),
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 10.0,
          ),
          child: new Divider(
            height: 1.0,
            color: ColorsInt.colorDivider,
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: ColorsInt.colorWhite,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorsInt.colorGray,
                    width: 1.0,
                  ),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: ColorsInt.colorGray,
                      blurRadius: 1.0,
                      offset: new Offset(0.0, 0.0),
                    ),
                  ],
                ),
                child: new Text(
                  "${currentQuestionPosition + 1}",
                  style: TextStyle(
                    fontFamily: "regular",
                    fontSize: 20.0,
                    color: ColorsInt.colorBlack,
                  ),
                ),
              ),
              new SizedBox(
                width: 10.0,
              ),
              new Expanded(
                child: (currentExamQuestionModel != null)
                    ? TeXView(
                        child: new TeXViewColumn(
                          children: [
                            TeXViewDocument(
                                currentExamQuestionModel.que_description ?? "",
                                style: TeXViewStyle(
                                    textAlign: TeXViewTextAlign.Left)),
                          ],
                        ),
                      )
                    : new Container(),
              ),
            ],
          ),
        ),
        new Expanded(
          child: new ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            itemCount: (currentExamQuestionModel == null)
                ? 0
                : currentExamQuestionModel.options.length,
            itemBuilder: (context, index) {
              final examQuestionOptionModel =
                  currentExamQuestionModel.options[index];

              bool isSelected = (currentExamQuestionModel.selectedIds != null &&
                  currentExamQuestionModel.selectedIds
                      .contains(examQuestionOptionModel.opt_id));

              return new InkWell(
                child: Container(
                  padding: EdgeInsets.only(
                      left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                  margin: EdgeInsets.only(top: 8.0),
                  decoration: BoxDecoration(
                    color: (isSelected)
                        ? ColorsInt.colorGreen2
                        : ColorsInt.colorWhite,
                    borderRadius: BorderRadius.all(Radius.circular(180.0)),
                    border: Border.all(
                      color: ColorsInt.colorGray,
                      width: 1.0,
                    ),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: ColorsInt.colorGray,
                        blurRadius: 1.0,
                        offset: new Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Visibility(
                        visible:
                            currentExamQuestionModel.que_ans_multiple == "1",
                        child: new Container(
                          height: 25.0,
                          width: 25.0,
                          margin: EdgeInsets.only(left: 5.0),
                          decoration: BoxDecoration(
                            color: (isSelected)
                                ? ColorsInt.colorGreen1
                                : ColorsInt.colorGray,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            shape: BoxShape.rectangle,
                          ),
                          child: null,
                        ),
                      ),
                      new Visibility(
                        visible:
                            currentExamQuestionModel.que_ans_multiple == "0",
                        child: new Container(
                          height: 25.0,
                          width: 25.0,
                          decoration: BoxDecoration(
                            color: (isSelected)
                                ? ColorsInt.colorGreen1
                                : ColorsInt.colorGray,
                            shape: BoxShape.circle,
                          ),
                          child: null,
                        ),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      new Expanded(
                        child: new Text(
                          examQuestionOptionModel.opt_description ?? "",
                          style: TextStyle(
                            fontFamily: "regular",
                            fontSize: 16.0,
                            color: ColorsInt.colorBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  answerClick(examQuestionOptionModel);
                },
              );
            },
          ),
        ),
        new SizedBox(
          height: 10.0,
        ),
        new Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                color: ColorsInt.colorWhite,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(180.0),
                    bottomRight: Radius.circular(180.0)),
                border: Border.all(
                  color: ColorsInt.colorGray,
                  width: 1.0,
                ),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: ColorsInt.colorGray,
                    blurRadius: 1.0,
                    offset: new Offset(0.0, 0.0),
                  ),
                ],
              ),
              child: new InkWell(
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      AppLocalizations.of(context).translate("prev"),
                      style: TextStyle(
                        fontFamily: "regular",
                        fontSize: 16.0,
                        color: ColorsInt.colorBlack,
                      ),
                    ),
                  ],
                ),
                onTap: () => prevClick(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                color: ColorsInt.colorWhite,
                borderRadius: BorderRadius.all(Radius.circular(180.0)),
                border: Border.all(
                  color: ColorsInt.colorGray,
                  width: 1.0,
                ),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: ColorsInt.colorGray,
                    blurRadius: 1.0,
                    offset: new Offset(0.0, 0.0),
                  ),
                ],
              ),
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "${currentQuestionPosition + 1}/${examQuestionModelList.length}",
                    style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 16.0,
                      color: ColorsInt.colorBlack,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                color: ColorsInt.colorWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(180.0),
                    bottomLeft: Radius.circular(180.0)),
                border: Border.all(
                  color: ColorsInt.colorGray,
                  width: 1.0,
                ),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: ColorsInt.colorGray,
                    blurRadius: 1.0,
                    offset: new Offset(0.0, 0.0),
                  ),
                ],
              ),
              child: new InkWell(
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      AppLocalizations.of(context).translate("next"),
                      style: TextStyle(
                        fontFamily: "regular",
                        fontSize: 16.0,
                        color: ColorsInt.colorBlack,
                      ),
                    ),
                  ],
                ),
                onTap: () => nextClick(),
              ),
            ),
          ],
        ),
        new SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
