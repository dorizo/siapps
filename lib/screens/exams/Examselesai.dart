import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:flutter/material.dart';

class Examselesai extends StatefulWidget {
  @override
  _ExamselesaiState createState() => _ExamselesaiState();
}

class _ExamselesaiState extends State<Examselesai> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(AppLocalizations.of(context).translate("Selamat")),
          backgroundColor: ColorsInt.colorPrimary,
          elevation: 0.0,
        ),
        body: Center(
          child: new Text("Selamat Ujian Online anda sudah selesai. \n \n Berdoa dan tawakkal agar hasil yang anda terima memuaskan. Hasil Ujian Online akan di umumkan oleh guru." ,
            textAlign: TextAlign.center),
        )
    );
  }
}
