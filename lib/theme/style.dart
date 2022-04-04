import 'package:flutter/material.dart';
import 'package:classes_app/theme/Color.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: ColorsInt.colorPrimary,
    accentColor: ColorsInt.colorPrimary,
    primaryColorDark: ColorsInt.colorPrimary,
    hintColor: ColorsInt.colorTextHint,
    dividerColor: ColorsInt.colorDivider,
    buttonColor: HexColor("#37969A"),
    scaffoldBackgroundColor: ColorsInt.colorBG,
    canvasColor: Colors.white,
    fontFamily: 'regular',
  );
}
