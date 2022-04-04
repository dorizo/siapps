import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:classes_app/screens/batches/Body.dart';

import 'package:classes_app/models/BatchModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/utils/CallApi.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';

class BatchesList extends StatefulWidget {
  @override
  _BatchesListState createState() => _BatchesListState();
}

class _BatchesListState extends State<BatchesList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  List<BatchModel> _batchModelList = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      makeGetBatchesList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("batches")),
        backgroundColor: ColorsInt.colorPrimary,
      ),
      body: new Body(
        batchModelList: _batchModelList,
      ),
    );
  }

  makeGetBatchesList(BuildContext context) {
    var url = BaseURL.GET_BATCHES_LIST_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);

    CallApi().post(context, url, map, true).then((response) {
      final List dataJson = json.decode(response);
      setState(() {
        _batchModelList.clear();
        _batchModelList.addAll(
            dataJson.map((val) => BatchModel.fromJson(val)).toList());
      });
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  _displaySnackBar(BuildContext context, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
