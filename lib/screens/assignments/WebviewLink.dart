import 'package:classes_app/models/HomeMenuModel.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebviewLink extends StatefulWidget {
  
  final String link;

  const WebviewLink({Key key, this.link}) : super(key: key);
  @override
  _WebviewLinkState createState() => _WebviewLinkState();
}

class _WebviewLinkState extends State<WebviewLink> {
  
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final HomeMenuModel args = ModalRoute.of(context).settings.arguments;
    print(args);
    return Scaffold( key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(args.icon),
        backgroundColor: ColorsInt.colorPrimary,
      ),
      body: WebviewScaffold(
      url: args.title,
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
                
              },
            )
          ],
        ),
        preferredSize: Size.fromHeight(0.0),
      ),

    )
    );
  }
}