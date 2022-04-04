import 'package:flutter/material.dart';
import 'package:classes_app/theme/Color.dart';

import 'package:classes_app/utils/app_localizations.dart';

class CustomLoader extends StatelessWidget {
  //CustomLoader(Key key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
            color: Colors.transparent,
            child: new Container(
              decoration: new BoxDecoration(
                  color: ColorsInt.colorPrimary,
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(20.0))),
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
          )
        ],
      ),
    );
  }
}
