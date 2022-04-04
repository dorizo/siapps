import 'package:classes_app/config/BaseURL.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:classes_app/components/CustomLoader.dart';

import 'package:classes_app/config/globals.dart' as globles;

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';

final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print('message.message: ${message.message}');
      }),
].toSet();

class Teacher extends StatefulWidget {
  @override
  _TeacherState createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  //WebViewController _controller;

  String loadUrl = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      setState(() {
        loadUrl = sharedPrefs.getString("Teacher_url");
      });
      //_showLoading(context);
    });

    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      print("changeUrl:$url");
      if (url == "${BaseURL.BASE_URL}/index.php") {
        sharedPrefs.clear().then((onValue) {
          Navigator.of(context).pushReplacementNamed('/login');
        });
      }
    });
  }

  Future<bool> _onWillPop() async {
    bool canback = await flutterWebViewPlugin.canGoBack();
    if (canback) {
      flutterWebViewPlugin.goBack();
    } else {
      SystemNavigator.pop();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            child: new AppBar(
              title: new Text(
                AppLocalizations.of(context).translate("app_name"),
                style: TextStyle(
                    fontFamily: "regular", color: ColorsInt.colorWhite),
              ),
              backgroundColor: ColorsInt.colorPrimary,
              elevation: 0.0,
              actions: <Widget>[
                new InkWell(
                  child: new Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 10.0),
                      child: new Icon(Icons.power_settings_new)),
                  onTap: () {
                    sharedPrefs.clear().then((onValue) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    });
                  },
                )
              ],
            ),
            preferredSize: Size.fromHeight(0.0)),
        body: (loadUrl != null && loadUrl.isNotEmpty)
            ? _webViewScaffold(loadUrl)
            : new Container(
                child: null,
              ),
      ),
    );
  }

  /*Widget _webView(String loadUrl) {
    return new WebView(
      initialUrl: loadUrl,
      onPageFinished: (some) async {
        if (globles.isDialogVisible) {
          _showLoading(context);
        }
        if (_controller != null) {
          double height = double.parse(await _controller
              .evaluateJavascript("document.documentElement.scrollHeight;"));
        }
      },
      */ /*gestureRecognizers: Set()
        ..add(
          Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer(),
          ), // or null
        ),*/ /*
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        if (_controller == null) {
          setState(() {
            _controller = webViewController;
          });
        }
      },
    );
  }*/

  Widget _webViewScaffold(String loadUrl) {
    return WebviewScaffold(
      url: loadUrl,
      appBar: PreferredSize(
        child: new AppBar(
          title: new Text(
            AppLocalizations.of(context).translate("app_name"),
            style:
                TextStyle(fontFamily: "regular", color: ColorsInt.colorWhite),
          ),
          backgroundColor: ColorsInt.colorPrimary,
          elevation: 0.0,
          actions: <Widget>[
            new InkWell(
              child: new Padding(
                  padding: EdgeInsets.only(right: 10.0, left: 10.0),
                  child: new Icon(Icons.power_settings_new)),
              onTap: () {
                sharedPrefs.clear().then((onValue) {
                  Navigator.of(context).pushReplacementNamed('/login');
                });
              },
            )
          ],
        ),
        preferredSize: Size.fromHeight(0.0),
      ),
      withLocalStorage: true,
      withJavascript: true,
      javascriptChannels: jsChannels,
      initialChild: Container(
        color: Colors.transparent,
        child: Center(
          child: new Container(
            decoration: new BoxDecoration(
                color: ColorsInt.colorPrimary,
                borderRadius: new BorderRadius.all(new Radius.circular(20.0))),
            padding: EdgeInsets.all(20.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(ColorsInt.colorWhite),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: new Text(
                    AppLocalizations.of(context).translate("loading"),
                    style: new TextStyle(
                      color: ColorsInt.colorWhite,
                      fontFamily: "regular",
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showLoading(BuildContext context) {
    if (!globles.isDialogVisible) {
      globles.isDialogVisible = true;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new CustomLoader();
          }).then((val) {
        globles.isDialogVisible = false;
      });
    } else {
      if (globles.isDialogVisible) {
        Navigator.of(context).pop();
      }
    }
  }
}
