import 'package:flutter/material.dart';

import 'package:classes_app/components/TextRegular.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';

import 'package:classes_app/config/globals.dart' as globle;

class ChooseLanguageDialog extends StatelessWidget {
  ChooseLanguageDialog({
    Key key,
    this.onArabicClick,
    this.onEnglishClick,
    this.onFrenchClick,
  }) : super(key: key);

  final VoidCallback onArabicClick;
  final VoidCallback onEnglishClick;
  final VoidCallback onFrenchClick;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      contentPadding: EdgeInsets.all(5.0),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
            width: double.infinity,
            decoration: new BoxDecoration(
                color: ColorsInt.colorWhite,
                borderRadius: new BorderRadius.all(new Radius.circular(20.0))),
            padding: EdgeInsets.all(10.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new TextRegular(
                  title:
                      AppLocalizations.of(context).translate("choose_language"),
                  size: 22,
                ),
                new InkWell(
                  child: new Padding(
                    padding: EdgeInsets.all(10),
                    child: new TextRegular(
                      title: AppLocalizations.of(context).translate("english"),
                      size: 16,
                      color: (globle.lang == "en")
                          ? ColorsInt.colorPrimary
                          : ColorsInt.colorGray,
                    ),
                  ),
                  onTap: () => onEnglishClick(),
                ),
                new Divider(
                  color: ColorsInt.colorDivider,
                  height: 1,
                  thickness: 1,
                ),
                new InkWell(
                  child: new Padding(
                    padding: EdgeInsets.all(10),
                    child: new TextRegular(
                      title: AppLocalizations.of(context).translate("arabic"),
                      size: 16,
                      color: (globle.lang == "ar")
                          ? ColorsInt.colorPrimary
                          : ColorsInt.colorGray,
                    ),
                  ),
                  onTap: () => onArabicClick(),
                ),
                new Divider(
                  color: ColorsInt.colorDivider,
                  height: 1,
                  thickness: 1,
                ),
                new InkWell(
                  child: new Padding(
                    padding: EdgeInsets.all(10),
                    child: new TextRegular(
                      title: AppLocalizations.of(context).translate("french"),
                      size: 16,
                      color: (globle.lang == "fr")
                          ? ColorsInt.colorPrimary
                          : ColorsInt.colorGray,
                    ),
                  ),
                  onTap: () => onFrenchClick(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
