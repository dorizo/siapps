import 'package:flutter/material.dart';

class ColorsInt {
  static const Color colorPrimary = Color(0XFF412279);

  static const Color colorWhite = Color(0XFFFFFFFF);
  static const Color colorBlack = Color(0XFF000000);
  static const Color colorOrange = Color(0XFFFB6566);
  static const Color colorOrangeDark = Color(0XFFD8403F);
  static const Color colorGray = Color(0XFFC1C1C1);
  static const Color colorText = Color(0XFF424242);
  static const Color colorTextHint = Color(0XFFB9B9B9);
  static const Color colorDivider = Color(0XFFCACACA);
  static const Color colorGreen = Color(0XFF38969A);
  static const Color colorCyan = Color(0XFF9BE2D2);
  static const Color colorBG = Color(0XFFF6F6F6);
  static const Color colorRed = Color(0XFFFF351A);
  static const Color colorGreen1 = Color(0XFF3BED8B);
  static const Color colorGreen2 = Color(0XFFDDFDE5);
  static const Color colorRed2 = Color(0XFFFF4848);
  static const Color colorDarkGreen = Color(0XFF448752);
  static const Color colorLightCyan = Color(0XFF9BE2D0);

  static const Color colorAttended = Color(0XFF52B75B);
  static const Color colorMissed = Color(0XFFE63E35);
  static const Color colorOnward = Color(0XFF558F81);

  static const Color colorBachesBG1 = Color(0XFFC4E9E1);
  static const Color colorBachesBG2 = Color(0XFFA5F1A4);
  static const Color colorBachesBG3 = Color(0XFFFBCEAF);

  static const Color colorBachesStatus2 = Color(0XFF3A8544);
  static const Color colorBachesStatus3 = Color(0XFFCF4343);

  static const Color colorWhiteTranspernat = Color(0X99FFFFFF);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
