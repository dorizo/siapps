import 'package:classes_app/models/AssignmentModel.dart';
import 'package:flutter/material.dart';
import 'package:classes_app/theme/Color.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:classes_app/utils/DateFormatter.dart';
import 'package:classes_app/screens/assignments/ViewDocument.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/config/globals.dart' as globle;
import 'package:auto_size_text/auto_size_text.dart';

class Body extends StatelessWidget {
  Body(
      {Key key,
      this.showFilter,
      @required this.selectedMonth,
      @required this.selectedYear,
      @required this.selectedClasses,
      @required this.monthList,
      @required this.yearList,
      @required this.classList,
      @required this.assignmentModelList,
      @required this.onMonthSelected,
      @required this.onYearSelected,
      @required this.onClassesSelected,
      @required this.onViewClick,
      @required this.onSubmitClick})
      : super(key: key);

  static DateTime now = new DateTime.now();

  int selectedMonth;
  String selectedYear;
  String selectedClasses;

  List<String> monthList;
  List<String> yearList;
  List<String> classList;
  List<AssignmentModel> assignmentModelList;
  bool showFilter;

  final Function(int) onMonthSelected;
  final Function(String) onYearSelected;
  final Function(String) onClassesSelected;
  final Function(AssignmentModel) onViewClick;
  final Function(AssignmentModel) onSubmitClick;

  @override
  Widget build(BuildContext context) {
    return new ListView(
      shrinkWrap: false,
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Visibility(
                visible: showFilter,
                child: new Container(
                  width: double.infinity,
                  color: ColorsInt.colorWhite,
                  padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Expanded(
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              AppLocalizations.of(context).translate("month"),
                              style: TextStyle(
                                color: ColorsInt.colorText,
                                fontFamily: 'regular',
                                fontSize: 12.0,
                              ),
                            ),
                            new DropdownButton<String>(
                              value: new DateFormat('MMMM', globle.lang).format(
                                  new DateTime(now.year, selectedMonth, 1)),
                              icon: Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: ColorsInt.colorText),
                              underline: Container(
                                height: 2,
                                color: Colors.transparent,
                              ),
                              onChanged: (String newValue) {
                                if (monthList.isNotEmpty) {
                                  onMonthSelected(
                                      monthList.indexOf(newValue) + 1);
                                }
                              },
                              items: monthList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: AutoSizeText(
                                    value,
                                    minFontSize: 12,
                                    maxLines: 1,
                                    maxFontSize: 18,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "regular",
                                        color: ColorsInt.colorBlack),
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                AppLocalizations.of(context).translate("year"),
                                style: TextStyle(
                                  color: ColorsInt.colorText,
                                  fontFamily: 'regular',
                                  fontSize: 12.0,
                                ),
                              ),
                              DropdownButton<String>(
                                value: new DateFormat('yyyy').format(
                                    new DateTime(int.parse(selectedYear), 1)),
                                icon: Icon(Icons.arrow_drop_down),
                                isExpanded: true,
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: ColorsInt.colorText),
                                underline: Container(
                                  height: 2,
                                  color: Colors.transparent,
                                ),
                                onChanged: (String newValue) =>
                                    onYearSelected(newValue),
                                items: yearList.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: AutoSizeText(
                                      value,
                                      minFontSize: 12,
                                      maxLines: 1,
                                      maxFontSize: 18,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: "regular",
                                          color: ColorsInt.colorBlack),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),
                      ),
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                AppLocalizations.of(context)
                                    .translate("classes"),
                                style: TextStyle(
                                  color: ColorsInt.colorText,
                                  fontFamily: 'regular',
                                  fontSize: 12.0,
                                ),
                              ),
                              DropdownButton<String>(
                                value: selectedClasses,
                                icon: Icon(Icons.arrow_drop_down),
                                isExpanded: true,
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: ColorsInt.colorText),
                                underline: Container(
                                  height: 2,
                                  color: Colors.transparent,
                                ),
                                onChanged: (String newValue) =>
                                    onClassesSelected(newValue),
                                items: classList.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: AutoSizeText(
                                      value,
                                      minFontSize: 12,
                                      maxLines: 1,
                                      maxFontSize: 18,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: "regular",
                                          color: ColorsInt.colorBlack),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            new SizedBox(
              height: 10.0,
            ),
            new ListView.builder(
                itemCount: assignmentModelList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, position) {
                  var assignmentModel = assignmentModelList[position];

                  return new Container(
                    width: double.infinity,
                    child: new Card(
                      margin: EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 10.0),
                      color: ColorsInt.colorWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0.0,
                      child: new Container(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                        child: new Column(
                          children: <Widget>[
                            new InkWell(
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          assignmentModel.assign_title ?? "",
                                          style: TextStyle(
                                              color: ColorsInt.colorText,
                                              fontSize: 18.0,
                                              fontFamily: "regular"),
                                        ),
                                        /*new Text(
                                        "${AppLocalizations.of(context).translate("submit_till_date")} ${DateFormatter.getConvetedDate(assignmentModel.assign_end_of_submission_date ?? "", 3)}",
                                        style: TextStyle(
                                            color: HexColor(
                                                ColorString.colorPrimary),
                                            fontSize: 12.0,
                                            fontFamily: "regular"),
                                      ),*/
                                        new Text(
                                          assignmentModel.batch_name ?? "",
                                          style: TextStyle(
                                              color: ColorsInt.colorText,
                                              fontSize: 12.0,
                                              fontFamily: "regular"),
                                        )
                                      ],
                                    ),
                                    flex: 1,
                                  ),
                                  new Image.asset(
                                    "assets/images/ic_arrow_right.png",
                                    height: 20.0,
                                    width: 20.0,
                                    matchTextDirection: true,
                                  ),
                                  /*new IntrinsicWidth(
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      new InkWell(
                                        onTap: () {
                                          onViewClick(assignmentModel);
                                        },
                                        child: new Container(
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)),
                                                border: Border.all(
                                                    color: HexColor(
                                                        ColorString.colorText),
                                                    width: 1.0)),
                                            child: new Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                new ImageIcon(
                                                  AssetImage(
                                                      "assets/images/ic_pdf.png"),
                                                  size: 15.0,
                                                ),
                                                new Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5.0),
                                                  child: new Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            "view_document"),
                                                    style: TextStyle(
                                                        color: HexColor(
                                                            ColorString
                                                                .colorText),
                                                        fontSize: 10.0,
                                                        fontFamily: "regular"),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                )*/
                                ],
                              ),
                              onTap: () {
                                onViewClick(assignmentModel);
                              },
                            ),
                            new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Container(
                                  child: new Divider(
                                    color: ColorsInt.colorDivider,
                                  ),
                                ),
                                new Container(
                                  child: new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Visibility(
                                        visible:
                                            (assignmentModel.submitted_date !=
                                                    null &&
                                                assignmentModel
                                                    .submitted_date.isNotEmpty),
                                        child: new ImageIcon(
                                          AssetImage(
                                              "assets/images/ic_doc.png"),
                                          size: 15.0,
                                        ),
                                      ),
                                      new Expanded(
                                        child: new Container(
                                          margin: EdgeInsets.only(left: 5.0),
                                          child: new Text(
                                            "${(assignmentModel.submitted_date != null && assignmentModel.submitted_date.isNotEmpty) ? AppLocalizations.of(context).translate("submitted_on") : AppLocalizations.of(context).translate("submit_till_date")} ${(assignmentModel.submitted_date != null && assignmentModel.submitted_date.isNotEmpty) ? DateFormatter.getConvetedDate(assignmentModel.submitted_date ?? "", 3) : assignmentModel.assign_end_of_submission_date}",
                                            style: TextStyle(
                                                color: (assignmentModel
                                                                .submitted_date !=
                                                            null &&
                                                        assignmentModel
                                                            .submitted_date
                                                            .isNotEmpty)
                                                    ? ColorsInt.colorText
                                                    : ColorsInt.colorRed,
                                                fontSize: 10.0,
                                                fontFamily: "regular"),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      new InkWell(
                                        onTap: () {
                                          onSubmitClick(assignmentModel);
                                        },
                                        child: new Container(
                                            child: new Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            new ImageIcon(
                                              AssetImage(
                                                  "assets/images/ic_submit.png"),
                                              size: 15.0,
                                            ),
                                            new Container(
                                              margin:
                                                  EdgeInsets.only(left: 5.0),
                                              child: new Text(
                                                (assignmentModel.submitted_date !=
                                                            null &&
                                                        assignmentModel
                                                            .submitted_date
                                                            .isNotEmpty)
                                                    ? AppLocalizations.of(
                                                            context)
                                                        .translate("re_submit")
                                                        .toUpperCase()
                                                    : AppLocalizations.of(
                                                            context)
                                                        .translate("submit")
                                                        .toUpperCase(),
                                                style: TextStyle(
                                                    color: ColorsInt.colorText,
                                                    fontSize: 10.0,
                                                    fontFamily: "regular"),
                                              ),
                                            ),
                                          ],
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ],
    );
  }
}
