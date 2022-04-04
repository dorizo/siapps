import 'package:classes_app/models/BatchModel.dart';
import 'package:classes_app/models/StudyMaterialModel.dart';
import 'package:classes_app/models/SubjectModel.dart';
import 'package:flutter/material.dart';
import 'package:classes_app/screens/study_material/bodys/BodyStudyMaterial.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:classes_app/config/BaseURL.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:classes_app/components/CustomLoader.dart';
import 'package:classes_app/utils/CallApi.dart';
import 'package:classes_app/utils/app_localizations.dart';

class StudyMaterial extends StatefulWidget {
  @override
  _StudyMaterialState createState() => _StudyMaterialState();
}

class _StudyMaterialState extends State<StudyMaterial> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;
  SharedPreferences sharedPrefs;
  List<StudyMaterialModel> _studyMaterialModelList = [];

  List<String> _subjectList = [];
  List<String> _batchesList = [];

  List<SubjectModel> _subjectModelList = [];
  List<BatchModel> _batchesModelList = [];

  String _selectedSubject;
  String _selectedBatches;

  String _selectedSubjectID = "";
  String _selectedBatchesID = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);

      setState(() {
        _subjectList.add(AppLocalizations.of(context).translate("all"));
        if (sharedPrefs.containsKey("subject_list")) {
          final List subjecttList =
          jsonDecode(sharedPrefs.getString("subject_list"));
          _subjectModelList.addAll(
              subjecttList.map((val) => SubjectModel.fromJson(val)).toList());
          if (_subjectModelList.length > 0) {
            /*_selectedBatches = _batchesModelList[0].batch_name;
          _selectedBatchesID = _batchesModelList[0].batch_id;*/
            _selectedSubject = AppLocalizations.of(context).translate("all");
            _selectedSubjectID = "0";
            for (int i = 0; i < _subjectModelList.length; i++) {
              _subjectList.add(_subjectModelList[i].subject_name);
            }
          }
        }
      });

      setState(() {
        _batchesList.add(AppLocalizations.of(context).translate("all"));
        if (sharedPrefs.containsKey("batches_list")) {
          final List studentList =
          jsonDecode(sharedPrefs.getString("batches_list"));
          _batchesModelList.addAll(
              studentList.map((val) => BatchModel.fromJson(val)).toList());
          if (_batchesModelList.length > 0) {
            _selectedBatches = AppLocalizations.of(context).translate("all");
            _selectedBatchesID = "0";
            for (int i = 0; i < _batchesModelList.length; i++) {
              _batchesList.add(_batchesModelList[i].batch_name);
            }
          }
        }
      });

      makeGetStudyMaterial(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("study_material")),
        backgroundColor: ColorsInt.colorPrimary,
      ),
      body: new BodyStudyMaterial(
        selectedSubject: _selectedSubject,
        selectedBatches: _selectedBatches,
        subjectList: _subjectList,
        batchesList: _batchesList,
        studyMaterialModelList: _studyMaterialModelList,
        onSubjectSelected: (newValue) {
          setState(() {
            var isNew = (_selectedSubject != newValue);
            var selectedSubject = _getSubjectDetailByName(newValue);
            if (selectedSubject != null) {
              _selectedSubject = newValue;
              _selectedSubjectID = selectedSubject.subject_id;
            } else {
              _selectedSubject = newValue;
              _selectedSubjectID = "0";
            }
            if (isNew) {
              makeGetStudyMaterial(context);
            }
          });
        },
        onBatchesSelected: (newValue) {
          setState(() {
            var isNew = (_selectedBatches != newValue);
            var selectedBatch = _getBatchDetailByName(newValue);
            if (selectedBatch != null) {
              _selectedBatches = newValue;
              _selectedBatchesID = selectedBatch.batch_id;
            } else {
              _selectedBatches = newValue;
              _selectedBatchesID = "0";
            }
            if (isNew) {
              makeGetStudyMaterial(context);
            }
          });
        },
      ),
    );
  }

  SubjectModel _getSubjectDetailByName(String name) {
    for (SubjectModel subjectModel in _subjectModelList) {
      if (subjectModel.subject_name == name) {
        return subjectModel;
      }
    }
    return null;
  }

  BatchModel _getBatchDetailByName(String name) {
    for (BatchModel batchModel in _batchesModelList) {
      if (batchModel.batch_name == name) {
        return batchModel;
      }
    }
    return null;
  }

  makeGetStudyMaterial(BuildContext context) {
    var url = BaseURL.GET_STUDY_MATERIAL_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);
    if (_selectedBatchesID != "0") map['batch'] = _selectedBatchesID;
    if (_selectedSubjectID != "0") map['subject'] = _selectedSubjectID;

    CallApi().post(context, url, map, true).then((response) {
      final List dataJson = json.decode(response);
      setState(() {
        _studyMaterialModelList.clear();
        _studyMaterialModelList.addAll(
            dataJson.map((val) => StudyMaterialModel.fromJson(val)).toList());
      });
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  bool isDialogShowing = false;

  void _showLoading() {
    if (_loading) {
      isDialogShowing = true;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new CustomLoader();
          });
    } else {
      if (isDialogShowing) {
        Navigator.of(context).pop();
      }
      isDialogShowing = false;
    }
  }

  _displaySnackBar(BuildContext context, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
