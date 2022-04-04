import 'package:flutter/material.dart';
import 'package:classes_app/theme/Color.dart';

class CustomRadioButtion extends StatelessWidget {
  CustomRadioButtion({Key key, this.title, this.onCheck, this.isChecked})
      : super(key: key);

  final title;
  final isChecked;
  VoidCallback onCheck;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        onCheck();
      },
      child: new Container(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Container(
              height: 25.0,
              width: 25.0,
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isChecked)
                    ? ColorsInt.colorOrangeDark
                    : ColorsInt.colorGray,
              ),
              child: new Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      (isChecked) ? ColorsInt.colorOrange : ColorsInt.colorGray,
                ),
                child: null,
              ),
            ),
            new SizedBox(
              width: 5.0,
            ),
            new Text(
              title,
              style: TextStyle(
                  fontSize: 16.0,
                  color: ColorsInt.colorText,
                  fontFamily: "regular"),
            )
          ],
        ),
      ),
    );
  }
}
