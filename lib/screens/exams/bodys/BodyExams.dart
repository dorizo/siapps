import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:classes_app/screens/exams/ExamResult.dart';
import 'package:classes_app/screens/exams/ExamOfflineResult.dart';

import 'package:classes_app/models/ExamModel.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/DateFormatter.dart';

class BodyExams extends StatelessWidget {
  BodyExams(
      {Key key,
      this.controller,
      this.offlineExamModelList,
      this.onlineExamModelList,
      this.goToNext})
      : super(key: key);

  final TabController controller;

  final List<ExamModel> offlineExamModelList;
  final List<ExamModel> onlineExamModelList;

  final Function(ExamModel, String) goToNext;

  @override
  Widget build(BuildContext context) {
    //return getList();
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: new TabBar(
            controller: controller,
            unselectedLabelColor: ColorsInt.colorBlack,
            labelColor: ColorsInt.colorBlack,
            indicatorColor: ColorsInt.colorPrimary,
            labelStyle: TextStyle(
              fontFamily: "regular",
              fontSize: 16.0,
            ),
            tabs: [
              Tab(
                icon: null,
                text: AppLocalizations.of(context).translate("online_exam"),
              ),
              Tab(
                icon: null,
                text: AppLocalizations.of(context).translate("offline_exam"),
              ),
            ],
          ),
        ),
        new Expanded(
          child: TabBarView(
            controller: controller,
            children: [
              getList("2", onlineExamModelList),
              getList("1", offlineExamModelList),
            ],
          ),
        ),
      ],
    );
  }

  Widget getList(String pageStoreKey, List<ExamModel> examModelList) {
    return new ListView.builder(
      shrinkWrap: true,
      key: new PageStorageKey(pageStoreKey),
      itemCount: (examModelList != null) ? examModelList.length : 0,
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      itemBuilder: (context, index) {
        final examModel = examModelList[index];

        int examStatus = 0;
        if (examModel.attempt_id != null && examModel.attempt_id.isNotEmpty) {
          if (int.parse(examModel.final_marks ?? "0") >=
              int.parse(examModel.exam_passing_marks ?? "0")) {
            examStatus = 1;
          }
        }
        return new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new SizedBox(
              height: 15.0,
            ),
            new Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  DateFormatter.getConvetedDate(examModel.exam_date, 4),
                  style: TextStyle(
                      color: ColorsInt.colorBlack,
                      fontSize: 16.0,
                      fontFamily: "regular"),
                ),
                new Text(
                  DateFormatter.getConvetedTime(
                          context, examModel.exam_start_time, 1)
                      .toUpperCase(),
                  style: TextStyle(
                      color: ColorsInt.colorBlack,
                      fontSize: 16.0,
                      fontFamily: "regular"),
                ),
              ],
            ),
            new InkWell(
              child: new Card(
                margin: EdgeInsets.zero,
                color: ColorsInt.colorWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
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
                              examModel.exam_title ?? "",
                              style: TextStyle(
                                fontFamily: "regular",
                                fontSize: 14.0,
                                color: ColorsInt.colorBlack,
                              ),
                            ),
                            new Text(
                              examModel.batches_name.replaceAll(",", "|") ?? "",
                              style: TextStyle(
                                fontFamily: "regular",
                                fontSize: 10.0,
                                color: ColorsInt.colorBlack,
                              ),
                            ),
                            new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new Text(
                                    AppLocalizations.of(context)
                                        .translate("time")
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: "regular",
                                      fontSize: 12.0,
                                      color: ColorsInt.colorCyan,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                new Flexible(
                                  child: new Text(
                                    "${examModel.exam_total_time.replaceAll(":00", "") ?? ""} Min"
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: "regular",
                                      fontSize: 12.0,
                                      color: ColorsInt.colorCyan,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                new SizedBox(
                                  width: 20.0,
                                ),
                                new Flexible(
                                  child: new Text(
                                    AppLocalizations.of(context)
                                        .translate("marks")
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: "regular",
                                      fontSize: 12.0,
                                      color: ColorsInt.colorOrange,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                new Flexible(
                                  child: new Text(
                                    (pageStoreKey == "1")
                                        ? examModel.total_obtain_marks ?? ""
                                        : examModel.exam_total_marks ?? "",
                                    style: TextStyle(
                                      fontFamily: "regular",
                                      fontSize: 12.0,
                                      color: ColorsInt.colorOrange,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      new Visibility(
                        visible: (examModel.attempt_id == null &&
                            pageStoreKey == "2"),
                        child: new InkWell(
                          child: new Container(
                            padding: EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(180.0)),
                              color: ColorsInt.colorPrimary,
                            ),
                            child: new Center(
                                child: new Text(
                              AppLocalizations.of(context)
                                  .translate("join_exam"),
                              style: TextStyle(
                                fontFamily: "regular",
                                color: ColorsInt.colorWhite,
                              ),
                            )),
                          ),
                          onTap: () {
                            goToNext(examModel, pageStoreKey);
                          },
                        ),
                      ),
                      new Visibility(
                        visible: ((pageStoreKey == "1" &&
                                examModel.total_obtain_marks != null &&
                                examModel.total_obtain_marks.isNotEmpty) ||
                            (pageStoreKey == "2" &&
                                examModel.attempt_id != null &&
                                examModel.attempt_id.isNotEmpty)),
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              (pageStoreKey == "1")
                                  ? "${(double.parse(examModel.total_obtain_marks) * 100 / double.parse(examModel.total_marks)).toStringAsFixed(1)}%"
                                  : examModel.final_marks ?? "",
                              style: TextStyle(
                                fontFamily: "bold",
                                fontSize: 18.0,
                                color: (pageStoreKey == "1" || examStatus == 1)
                                    ? ColorsInt.colorGreen
                                    : ColorsInt.colorRed,
                              ),
                            ),
                            new Visibility(
                              visible: (pageStoreKey == "2"),
                              child: new Text(
                                AppLocalizations.of(context).translate(
                                    (examStatus == 1) ? "pass" : "failed"),
                                style: TextStyle(
                                  fontFamily: "regular",
                                  fontSize: 14.0,
                                  color: (examStatus == 1)
                                      ? ColorsInt.colorGreen
                                      : ColorsInt.colorRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                if (pageStoreKey == "1") {
                  goToNext(examModel, pageStoreKey);
                } else {
                  if (examModel.attempt_id != null &&
                      examModel.attempt_id.isNotEmpty) {
                    goToNext(examModel, pageStoreKey);
                  }
                }
              },
            )
          ],
        );
      },
    );
  }

  goNextScreen(BuildContext context, ExamModel examModel, String examType) {
    if (examType == "2" &&
        examModel.attempt_id != null &&
        examModel.attempt_id.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExamResult(
                    examModel: examModel,
                  )));
      //goToNext(examModel);
    } else if (examType == "1" &&
        examModel.total_obtain_marks != null &&
        examModel.total_obtain_marks.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExamOfflineResult(
                    examModel: examModel,
                  )));
      //goToNext(examModel);
    } else if (examModel.attempt_id == null) {
      if (examModel.exam_on_schedule == "0" &&
          DateFormatter.isDateValid(examModel.exam_date)) {
        /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExamStart(
                      examModel: examModel,
                    )));*/
        goToNext(examModel, examType);
      } else {
        if (DateFormatter.isDateValid(examModel.exam_date) &&
            DateFormatter.isTimeValid(examModel.exam_start_time,
                int.parse(examModel.exam_schedule_min))) {
          /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExamStart(
                        examModel: examModel,
                      )));*/
          goToNext(examModel, examType);
        }
      }
    }
  }
}
