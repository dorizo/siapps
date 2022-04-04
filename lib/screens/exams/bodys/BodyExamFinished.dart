import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/DateFormatter.dart';

class BodyExamFinished extends StatelessWidget {
  BodyExamFinished({
    Key key,
    this.totalSpendSeconds,
    this.totalQuestion,
    this.totalCurrectAnswer,
    this.totalWrongAnswer,
    this.totalSkipedAnswer,
    this.onResultClick,
  }) : super(key: key);

  final int totalSpendSeconds;
  final String totalQuestion;
  final String totalCurrectAnswer;
  final String totalWrongAnswer;
  final String totalSkipedAnswer;

  final VoidCallback onResultClick;

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          width: double.infinity,
          padding:
              EdgeInsets.only(bottom: 40.0, left: 20.0, right: 20.0, top: 50.0),
          decoration: BoxDecoration(
              color: ColorsInt.colorPrimary,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0))),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                AppLocalizations.of(context).translate("thanks"),
                style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "regular",
                    color: ColorsInt.colorWhite),
              ),
              new Text(
                AppLocalizations.of(context)
                    .translate("being_participate_in_exam"),
                style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "regular",
                    color: ColorsInt.colorWhite),
              ),
            ],
          ),
        ),
        new Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.only(top: 110.0, left: 20.0, right: 20.0),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Image.asset(
                "assets/images/ic_exams.png",
                height: 100.0,
                width: 100.0,
              ),
              new SizedBox(
                height: 8.0,
              ),
              new Text(
                "${AppLocalizations.of(context).translate("spent")} ${DateFormatter.formatHHMMSS(totalSpendSeconds)} Min",
                style: TextStyle(
                    fontSize: 14.0,
                    color: ColorsInt.colorGray,
                    fontFamily: "regular"),
              ),
              new Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 50.0),
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      color: ColorsInt.colorWhite,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                totalCurrectAnswer,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: ColorsInt.colorGreen,
                                    fontFamily: "regular"),
                              ),
                              new Text(
                                AppLocalizations.of(context)
                                    .translate("correct"),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: ColorsInt.colorGreen,
                                    fontFamily: "regular"),
                              ),
                            ],
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                totalWrongAnswer,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: ColorsInt.colorRed,
                                    fontFamily: "regular"),
                              ),
                              new Text(
                                AppLocalizations.of(context).translate("wrong"),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: ColorsInt.colorRed,
                                    fontFamily: "regular"),
                              ),
                            ],
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                totalSkipedAnswer,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: ColorsInt.colorGray,
                                    fontFamily: "regular"),
                              ),
                              new Text(
                                AppLocalizations.of(context)
                                    .translate("skipped"),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: ColorsInt.colorGray,
                                    fontFamily: "regular"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Align(
                    alignment: Alignment.topCenter,
                    child: new Container(
                      margin: EdgeInsets.only(top: 10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: ColorsInt.colorPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: new Text(
                        totalQuestion,
                        style: TextStyle(
                            fontSize: 25.0,
                            color: ColorsInt.colorWhite,
                            fontFamily: "bold"),
                      ),
                    ),
                  ),
                ],
              ),
              new SizedBox(
                height: 10.0,
              ),
              new Text(
                AppLocalizations.of(context).translate("score_board"),
                style: TextStyle(
                    fontSize: 14.0,
                    color: ColorsInt.colorBlack,
                    fontFamily: "regular"),
              ),
              new SizedBox(
                height: 10.0,
              ),
              new Image.asset(
                "assets/images/ic_exams.png",
                height: 100.0,
                width: 100.0,
              ),
              new Expanded(
                child: new Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new InkWell(
                      child: Container(
                        width: double.infinity,
                        height: 45.0,
                        margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          color: ColorsInt.colorPrimary,
                          borderRadius:
                              BorderRadius.all(Radius.circular(180.0)),
                        ),
                        child: new Center(
                          child: new Text(
                            AppLocalizations.of(context)
                                .translate("show_result"),
                            style: TextStyle(
                                fontSize: 14.0,
                                color: ColorsInt.colorWhite,
                                fontFamily: "regular"),
                          ),
                        ),
                      ),
                      onTap: () => onResultClick(),
                    ),
                    new InkWell(
                      child: Container(
                        width: double.infinity,
                        height: 45.0,
                        margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          color: ColorsInt.colorPrimary,
                          borderRadius:
                              BorderRadius.all(Radius.circular(180.0)),
                        ),
                        child: new Center(
                          child: new Text(
                            AppLocalizations.of(context)
                                .translate("continue_to_app"),
                            style: TextStyle(
                                fontSize: 14.0,
                                color: ColorsInt.colorWhite,
                                fontFamily: "regular"),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
