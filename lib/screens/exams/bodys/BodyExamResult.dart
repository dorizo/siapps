import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'dart:math';

import 'package:classes_app/models/ExamQuestionModel.dart';
import 'package:classes_app/models/ExamQuestionOptionModel.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/ListViewEffect.dart';

class BodyExamResult extends StatelessWidget {
  BodyExamResult({Key key, this.examQuestionModelList}) : super(key: key);

  final List<ExamQuestionModel> examQuestionModelList;

  @override
  Widget build(BuildContext context) {
    return new ListViewEffect(
      duration: Duration(milliseconds: 200),
      animationType: 1,
      children: examQuestionModelList
          .map((s) => _buildWidgetExample(context, s))
          .toList(),
    );
  }

  Widget _buildWidgetExample(
      BuildContext context, ExamQuestionModel examQuestionModel) {
    List<String> attemptIds = [];

    if (examQuestionModel.option_ids != null) {
      final optionIdList = examQuestionModel.option_ids.split(",");
      for (int i = 0; i < optionIdList.length; i++) {
        attemptIds.add(optionIdList[i].trim());
      }
      //attemptIds.addAll(examQuestionModel.option_ids.split(","));
      if (attemptIds.length <= 0) {
        attemptIds.add(examQuestionModel.option_ids);
      }
    }

    print("attepmtIDs:${attemptIds.toString()}");

    List<ExamQuestionOptionModel> examlist = [];
    List<ExamQuestionOptionModel> examlistCurrect = [];
    List<ExamQuestionOptionModel> examlistAnswer = [];
    ExamQuestionOptionModel correctOption;

    for (int i = 0; i < examQuestionModel.options.length; i++) {
      final option = examQuestionModel.options[i];
      if (option.opt_is_correct == "1") {
        examlistCurrect.add(option);
      }
      if (attemptIds.contains(option.opt_id)) {
        examlistAnswer.add(option);
      }
    }

    return new Card(
        margin: EdgeInsets.only(
            top: 10.0,
            left: 20.0,
            right: 20.0,
            bottom: /*(index == 9) ? 10.0 :*/ 0.0),
        color: ColorsInt.colorWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: new Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TeXView(
                  key: ValueKey(new Random().nextInt(100)),
                  child: new TeXViewColumn(
                    children: [
                      TeXViewDocument(examQuestionModel.que_description ?? "",
                          style:
                              TeXViewStyle(textAlign: TeXViewTextAlign.Left)),
                    ],
                  ),
                ),
                new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Visibility(
                      visible: (examQuestionModel.marks_apply_in != "1"),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text(
                            AppLocalizations.of(context)
                                .translate("correct_answer"),
                            style: TextStyle(
                                fontFamily: "regular",
                                fontSize: 10.0,
                                color: ColorsInt.colorText),
                          ),
                          new SizedBox(
                            width: 10.0,
                          ),
                          new Expanded(
                            child:
                                _getAnswerList(context, examlistCurrect, false),
                          ),
                        ],
                      ),
                    ),
                    new Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(
                          AppLocalizations.of(context).translate("your_answer"),
                          style: TextStyle(
                              fontFamily: "regular",
                              fontSize: 12.0,
                              color: ColorsInt.colorText),
                        ),
                        new SizedBox(
                          width: 10.0,
                        ),
                        new Expanded(
                          child: _getAnswerList(context, examlistAnswer, true),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )));
  }

  Widget _getAnswerList(BuildContext context,
      List<ExamQuestionOptionModel> examlist, bool isAnswer) {
    return new ListView.builder(
        shrinkWrap: true,
        itemCount: examlist.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index1) {
          final examQuestionOptionModel = examlist[index1];

          Color questionColor;
          switch (examQuestionOptionModel.opt_is_correct) {
            case "1":
              questionColor = ColorsInt.colorGreen;
              break;
            case "0":
              questionColor = ColorsInt.colorRed;
              break;
            default:
              questionColor = ColorsInt.colorText;
              break;
          }

          return new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Visibility(
                visible: examlist.length > 1,
                child: new Text(
                  "${index1 + 1}) ",
                  style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 12.0,
                      color: ColorsInt.colorText),
                ),
              ),
              new Flexible(
                child: new Text(
                  examQuestionOptionModel.opt_description ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "regular",
                    fontSize: 12.0,
                    color: (isAnswer) ? questionColor : ColorsInt.colorText,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
