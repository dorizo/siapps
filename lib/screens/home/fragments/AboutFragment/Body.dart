import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

import 'package:classes_app/models/ClassesModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';

class Body extends StatelessWidget {
  Body(
      {Key key,
      this.classesModel,
      this.webHeight,
      this.controller,
      this.emailClick,
      this.callClick,
      this.siteClick,
      this.mapClick,
      this.setWebHeight,
      this.setWebController})
      : super(key: key);

  ClassesModel classesModel;

  double webHeight;

  VoidCallback emailClick;
  VoidCallback callClick;
  VoidCallback siteClick;
  VoidCallback mapClick;
  Function(double) setWebHeight;
  Function(InAppWebViewController) setWebController;

  InAppWebViewController controller;

  @override
  Widget build(BuildContext context) {
    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        new Stack(
          children: <Widget>[
            new Container(
              width: double.infinity,
              height: 70.0,
              padding: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
              margin: EdgeInsets.only(bottom: 30.0),
              decoration: BoxDecoration(
                  color: ColorsInt.colorPrimary,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0))),
              child: null,
            ),
            new Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: new Center(
                  child: new Hero(
                    tag: "studentphoto",
                    child: new CircleAvatar(
                      radius: 50.0,
                      backgroundImage: new NetworkImage(
                          "${BaseURL.IMG_CLASSES}${(classesModel != null) ? classesModel.classis_logo : ""}"),
                      backgroundColor: ColorsInt.colorGray,
                    ),
                  ),
                )),
            /*new Positioned(
                right: 50,
                bottom: 8,
                child: new InkWell(
                  child: new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(180.0),
                    ),
                    color: ColorsInt.colorGreen1,
                    child: new Padding(
                      padding: EdgeInsets.all(5.0),
                      child: new Image.asset(
                        "assets/images/ic_call_white.png",
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                  ),
                  onTap: () => callClick(),
                )),*/
          ],
        ),
        new SizedBox(
          height: 10.0,
        ),
        new Center(
          child: new Text(
            (classesModel != null) ? classesModel.classis_name ?? "" : "",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "bold",
              color: ColorsInt.colorBlack,
            ),
          ),
        ),
        new SizedBox(
          height: 20.0,
        ),
        new Center(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new InkWell(
                child: new Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(180.0),
                  ),
                  color: ColorsInt.colorGreen1,
                  child: new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Icon(
                      Icons.alternate_email,
                      size: 30.0,
                      color: ColorsInt.colorWhite,
                    ),
                  ),
                ),
                onTap: () => emailClick(),
              ),
              new InkWell(
                child: new Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(180.0),
                  ),
                  color: ColorsInt.colorGreen1,
                  child: new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Icon(
                      Icons.call,
                      size: 30.0,
                      color: ColorsInt.colorWhite,
                    ),
                  ),
                ),
                onTap: () => callClick(),
              ),
              new InkWell(
                child: new Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(180.0),
                  ),
                  color: ColorsInt.colorGreen1,
                  child: new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Icon(
                      Icons.web,
                      size: 30.0,
                      color: ColorsInt.colorWhite,
                    ),
                  ),
                ),
                onTap: () => siteClick(),
              ),
            ],
          ),
        ),
        new SizedBox(
          height: 20.0,
        ),
        new Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                AppLocalizations.of(context).translate("board"),
                style: TextStyle(
                    fontFamily: "bold",
                    fontSize: 14.0,
                    color: ColorsInt.colorText),
              ),
              new Text(
                (classesModel != null) ? classesModel.classis_board ?? "" : "",
                style: TextStyle(
                    fontFamily: "regular",
                    fontSize: 14.0,
                    color: ColorsInt.colorTextHint),
              ),
              new SizedBox(
                height: 20.0,
              ),
              new Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          AppLocalizations.of(context).translate("address"),
                          style: TextStyle(
                              fontFamily: "bold",
                              fontSize: 14.0,
                              color: ColorsInt.colorText),
                        ),
                        new Text(
                          (classesModel != null)
                              ? classesModel.classis_address ?? ""
                              : "",
                          style: TextStyle(
                              fontFamily: "regular",
                              fontSize: 14.0,
                              color: ColorsInt.colorTextHint),
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  new Visibility(
                      visible: (classesModel != null &&
                          double.parse(classesModel.classis_lat ?? 0) > 0 &&
                          double.parse(classesModel.classis_lon ?? 0) > 0),
                      child: new InkWell(
                        child: new Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(180.0),
                          ),
                          color: ColorsInt.colorPrimary,
                          child: new Padding(
                            padding: EdgeInsets.all(5.0),
                            child: new Icon(
                              Icons.map,
                              size: 30.0,
                              color: ColorsInt.colorWhite,
                            ),
                          ),
                        ),
                        onTap: () => mapClick(),
                      )),
                ],
              ),
              new SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
        (classesModel != null)
            ? new Visibility(
                visible: (classesModel != null &&
                    classesModel.classis_details != null &&
                    classesModel.classis_details.isNotEmpty),
                child: new Container(
                  height: webHeight,
                  width: double.infinity,
                  child: InAppWebView(
                    initialData: InAppWebViewInitialData(
                        data:
                            "<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0'></head><body>${classesModel.classis_details ?? ""}</body></html>",
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
              )
            : new Container(
                child: null,
              ),
      ],
    );
  }
}
