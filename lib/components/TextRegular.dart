import 'package:flutter/material.dart';
import 'package:classes_app/theme/Color.dart';

class TextRegular extends StatelessWidget {
  TextRegular({this.title, this.size, this.color});

  final String title;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return new Text(
      title,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: (size != null && size > 0) ? size : 14.0,
        color: (color != null) ? color : ColorsInt.colorText,
        fontFamily: "regular",
      ),
    );
  }
}
