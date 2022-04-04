import 'package:flutter/material.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';

class CommonAlert extends StatelessWidget {
  CommonAlert(
      {Key key,
      this.message,
      this.okText,
      this.cancelText,
      this.okClick,
      this.cancelClick})
      : super(key: key);

  String message;
  String okText;
  String cancelText;

  VoidCallback okClick;
  VoidCallback cancelClick;

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(0.0),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            color: Colors.transparent,
            child: new Container(
              width: double.infinity,
              decoration: new BoxDecoration(
                  color: ColorsInt.colorWhite,
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(10.0))),
              padding: EdgeInsets.all(20.0),
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new Text(
                    message ?? "",
                    style: TextStyle(
                        fontFamily: "regular", color: ColorsInt.colorText),
                  ),
                  new Divider(
                    color: ColorsInt.colorDivider,
                  ),
                  new Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Visibility(
                        visible: cancelClick != null,
                        child: new InkWell(
                          child: new Text(
                            (cancelText != null)
                                ? cancelText
                                : AppLocalizations.of(context)
                                    .translate("cancel"),
                            style: TextStyle(
                                fontFamily: "regular",
                                color: ColorsInt.colorText,
                                fontSize: 18.0),
                          ),
                          onTap: () {
                            if (cancelClick != null) {
                              cancelClick();
                            }
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      new SizedBox(
                        width: 20.0,
                      ),
                      new InkWell(
                        child: new Text(
                          (okText != null)
                              ? okText
                              : AppLocalizations.of(context).translate("ok"),
                          style: TextStyle(
                              fontFamily: "regular",
                              color: ColorsInt.colorText,
                              fontSize: 18.0),
                        ),
                        onTap: () {
                          if (okClick != null) {
                            okClick();
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ],
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
