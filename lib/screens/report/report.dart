import 'package:classes_app/models/HomeMenuModel.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:path_provider/path_provider.dart';

class Report extends StatefulWidget {
  
  final String link;
  

  const Report({Key key, this.link}) : super(key: key);
  @override
  _WebviewLinkState createState() => _WebviewLinkState();
}

class _WebviewLinkState extends State<Report> {
  
  InAppWebViewController _webViewController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double progress = 0;
  @override
  Widget build(BuildContext context) {
    final HomeMenuModel args = ModalRoute.of(context).settings.arguments;
    print(args);
    return Scaffold( key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(args.icon),
        backgroundColor: ColorsInt.colorPrimary,
      ),
       body: Container(
            child: 
                    Column(children: <Widget>[
                        Container(
                padding: EdgeInsets.all(0.0),
                child: progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container()),
              Expanded(
                  child: InAppWebView(
                    initialUrl: args.title,
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: true,
                          useOnDownloadStart: true
                      ),
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      _webViewController = controller;
                    },
                  onProgressChanged: (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                    onDownloadStart: (controller, url) async {
                      print("onDownloadStart $url");
                      final taskId = await FlutterDownloader.enqueue(
                        url: url,
                        savedDir: (await getExternalStorageDirectory()).path,
                        showNotification: true, // show download progress in status bar (for Android)
                        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                      );
                    },
                  ))
            ])),
    //   body: WebviewScaffold(
    //   url: args.title,
    //   appBar: PreferredSize(
    //     child: new AppBar(
    //       title: new Text(
    //         AppLocalizations.of(context).translate("app_name"),
    //         style:
    //             TextStyle(fontFamily: "regular", color: ColorsInt.colorWhite),
    //       ),
    //       backgroundColor: ColorsInt.colorPrimary,
    //       elevation: 0.0,
    //       actions: <Widget>[
    //         new InkWell(
    //           child: new Padding(
    //               padding: EdgeInsets.only(right: 10.0, left: 10.0),
    //               child: new Icon(Icons.power_settings_new)),
    //           onTap: () {
                
    //           },
    //         )
    //       ],
    //     ),
    //     preferredSize: Size.fromHeight(0.0),
    //   ),

    // )
    );
  }
}