import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_tex/flutter_tex.dart';

import 'package:classes_app/models/StudyMaterialModel.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/components/TextRegular.dart';
import 'package:classes_app/utils/DateFormatter.dart';
import 'package:classes_app/utils/app_localizations.dart';

class BodyStudyMaterialDetail extends StatelessWidget {
  BodyStudyMaterialDetail(
      {Key key,
      @required this.studyMaterialModel,
      this.webHeight,
      this.controller,
      this.setWebController,
      this.setWebHeight,
      this.startDownload,
      this.startView})
      : super(key: key);

  final StudyMaterialModel studyMaterialModel;
  final double webHeight;

  final Function(double) setWebHeight;
  final Function(InAppWebViewController) setWebController;

  final InAppWebViewController controller;

  final VoidCallback startDownload;
  final VoidCallback startView;

  @override
  Widget build(BuildContext context) {
    return /*ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[*/
        new Container(
      padding:
          EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 20.0),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Stack(
            children: <Widget>[
              new Card(
                margin: EdgeInsets.only(top: 10.0, bottom: 25.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                elevation: 0.0,
                child: new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new TextRegular(
                                title: studyMaterialModel.title ?? "",
                                size: 16.0,
                              ),
                              new RichText(
                                text: new TextSpan(children: <TextSpan>[
                                  new TextSpan(
                                    text: studyMaterialModel.subject_name ?? "",
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
                                    text: studyMaterialModel.batches ?? "",
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
                      /*new Icon(
                        Icons.arrow_forward_ios,
                        color: ColorsMy.colorTextHint,
                      ),*/
                    ],
                  ),
                ),
              ),
              new Visibility(
                  visible: (studyMaterialModel.type != null &&
                      (studyMaterialModel.type == "doc" ||
                          studyMaterialModel.type == "image")),
                  child: new Positioned(
                      bottom: 0,
                      right: 10,
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Visibility(
                            visible: (studyMaterialModel.type != null &&
                                studyMaterialModel.type == "doc"),
                            child: new InkWell(
                              child: new Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: ColorsInt.colorPrimary,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/images/ic_view.png",
                                  color: ColorsInt.colorWhite,
                                ),
                              ),
                              onTap: () => startView(),
                            ),
                          ),
                          new SizedBox(
                            width: 10.0,
                          ),
                          new InkWell(
                            child: new Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: ColorsInt.colorPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/images/ic_doc.png",
                                color: ColorsInt.colorWhite,
                              ),
                            ),
                            onTap: () => startDownload(),
                          ),
                        ],
                      ))),
            ],
          ),
          new Visibility(
            visible: (studyMaterialModel.description != null &&
                studyMaterialModel.description.isNotEmpty),
            child: TeXView(
              loadingWidgetBuilder: (context) => new Center(
                child: new CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(ColorsInt.colorPrimary),
                ),
              ),
              child: new TeXViewColumn(
                children: [
                  TeXViewDocument(
                    studyMaterialModel.description ?? "",
                    style: TeXViewStyle(
                      textAlign: TeXViewTextAlign.Left,
                      backgroundColor: ColorsInt.colorBG,
                    ),
                  ),
                ],
              ),
            ),
          ),
          /*new Visibility(
            visible: (studyMaterialModel.description != null &&
                studyMaterialModel.description.isNotEmpty),
            child: new Container(
              height: webHeight,
              width: double.infinity,
              child: InAppWebView(
                initialData: InAppWebViewInitialData(
                    data:
                        "<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0'></head><body>${studyMaterialModel.description ?? ""}</body></html>",
                    mimeType: 'text/html'),
                //initialUrl: 'about:blank',
                initialOptions: new InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        javaScriptEnabled: true, supportZoom: false)),
                onWebViewCreated: (controller) {
                  setWebController(controller);
                },
                onLoadStop: (controller, url) async {
                  print("onLoadStop $url");
                  controller.evaluateJavascript(
                      source:
                          '''(() => { return document.body.scrollHeight;})()''').then(
                      (value) {
                    if (value == null || value == '') {
                      return;
                    }
                    double height = double.parse('$value');
                    setWebHeight(height);
                  });
                },
              ),
            ),
          ),*/
        ],
      ),
    );
    /*,
      ],
    );*/
  }
}
