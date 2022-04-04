import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:classes_app/models/StudyMaterialModel.dart';


import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/components/TextRegular.dart';
import 'package:classes_app/utils/DateFormatter.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/config/BaseURL.dart';

class BodyStudyMaterial extends StatelessWidget {
  BodyStudyMaterial(
      {Key key,
      @required this.selectedSubject,
      @required this.selectedBatches,
      @required this.subjectList,
      @required this.batchesList,
      @required this.onSubjectSelected,
      @required this.onBatchesSelected,
      @required this.studyMaterialModelList})
      : super(key: key);

  final List<StudyMaterialModel> studyMaterialModelList;

  final String selectedSubject;
  final String selectedBatches;

  final List<String> subjectList;
  final List<String> batchesList;

  final Function(String) onSubjectSelected;
  final Function(String) onBatchesSelected;

  @override
  Widget build(BuildContext context) {
    return new ListView(
      shrinkWrap: false,
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Container(
              width: double.infinity,
              color: ColorsInt.colorWhite,
              padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  (subjectList.isEmpty)
                      ? new Container()
                      : new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                AppLocalizations.of(context)
                                    .translate("subject"),
                                style: TextStyle(
                                  color: ColorsInt.colorText,
                                  fontFamily: 'regular',
                                  fontSize: 12.0,
                                ),
                              ),
                              DropdownButton<String>(
                                value: selectedSubject ?? AppLocalizations.of(context).translate("all"),
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: ColorsInt.colorText),
                                underline: Container(
                                  height: 2,
                                  color: Colors.transparent,
                                ),
                                onChanged: (String newValue) {
                                  onSubjectSelected(newValue);
                                },
                                items: subjectList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value ?? "",
                                    child: AutoSizeText(
                                      value ?? "",
                                      minFontSize: 12,
                                      maxLines: 1,
                                      maxFontSize: 18,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "regular",
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                  new SizedBox(
                    width: 20.0,
                  ),
                  (batchesList.isEmpty)
                      ? new Container()
                      : new Expanded(
                          child: new Container(
                            margin: EdgeInsets.only(left: 20.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  AppLocalizations.of(context)
                                      .translate("batches"),
                                  style: TextStyle(
                                    color: ColorsInt.colorText,
                                    fontFamily: 'regular',
                                    fontSize: 12.0,
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: selectedBatches ?? AppLocalizations.of(context).translate("all"),
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  isExpanded: true,
                                  elevation: 16,
                                  style: TextStyle(color: ColorsInt.colorText),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (String newValue) =>
                                      onBatchesSelected(newValue),
                                  items: batchesList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value ?? "",
                                      child: AutoSizeText(
                                        value ?? "",
                                        minFontSize: 12,
                                        maxLines: 1,
                                        maxFontSize: 18,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: "regular",
                                        ),
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
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: studyMaterialModelList.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  var studyMaterialModel = studyMaterialModelList[index];

                  var thumbIcon = "assets/images/ic_doc.png";
                  var thumbVisible = true;
                  if (studyMaterialModel.type == "doc") {
                    thumbIcon = "assets/images/ic_doc.png";
                    thumbVisible = true;
                  } else if (studyMaterialModel.type == "video") {
                    thumbIcon = "assets/images/ic_video.png";
                    thumbVisible = true;
                  } else if (studyMaterialModel.type == "desc") {
                    thumbIcon = "assets/images/ic_txt.png";
                    thumbVisible = false;
                  } else if (studyMaterialModel.type == "image") {
                    thumbIcon = "assets/images/ic_image.png";
                    thumbVisible = false;
                  }

                  String finalUrl;
                  String fileUrl = studyMaterialModel.file;
                  if (fileUrl != null && fileUrl.isNotEmpty) {
                    if (fileUrl[0] == ".") {
                      fileUrl = fileUrl.substring(1);
                    }
                    finalUrl = BaseURL.BASE_URL + fileUrl;
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
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => StudyMaterialDetail(
                          //               studyMaterialModel: studyMaterialModel,
                          //             )));
                          /*Navigator.of(context)
                              .pushNamed('/study_material_detail');*/
                        },
                        child: new Container(
                          padding: EdgeInsets.all(10.0),
                          child: new Column(
                            children: <Widget>[
                              new Visibility(
                                  visible: (studyMaterialModel.type == "image"),
                                  child: new Container(
                                    width: double.infinity,
                                    height: 150.0,
                                    color: Colors.transparent,
                                    child: new Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      color: ColorsInt.colorWhite,
                                      elevation: 0.0,
                                      child: new Image.network(finalUrl ?? ""),
                                    ),
                                  )),
                              new Row(
                                children: <Widget>[
                                  new Visibility(
                                      visible: thumbVisible,
                                      child: new Container(
                                        width: 60.0,
                                        height: 60.0,
                                        color: Colors.transparent,
                                        child: new Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          color: ColorsInt.colorTextHint,
                                          child: new ImageIcon(
                                              AssetImage(thumbIcon)),
                                        ),
                                      )),
                                  new Expanded(
                                    child: new Container(
                                      margin: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new TextRegular(
                                            title:
                                                studyMaterialModel.title ?? "",
                                            size: 16.0,
                                          ),
                                          new RichText(
                                            text: new TextSpan(children: <
                                                TextSpan>[
                                              new TextSpan(
                                                text: studyMaterialModel
                                                        .subject_name ??
                                                    "",
                                                style: TextStyle(
                                                    color: ColorsInt.colorCyan,
                                                    fontSize: 12.0,
                                                    fontFamily: 'regular'),
                                              ),
                                              new TextSpan(
                                                text: " | ",
                                                style: TextStyle(
                                                    color: ColorsInt.colorText,
                                                    fontSize: 12.0,
                                                    fontFamily: 'regular'),
                                              ),
                                              new TextSpan(
                                                text: studyMaterialModel
                                                        .batches ??
                                                    "",
                                                style: TextStyle(
                                                    color: ColorsInt.colorText,
                                                    fontSize: 12.0,
                                                    fontFamily: 'regular'),
                                              ),
                                            ]),
                                          ),
                                          new TextRegular(
                                            title:
                                                "${AppLocalizations.of(context).translate("posted_on")} ${DateFormatter.getConvetedDateTime(context, studyMaterialModel.created_at ?? "", 2)}",
                                            size: 12.0,
                                            color: ColorsInt.colorText,
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
                              )
                            ],
                          ),
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
