import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'dart:isolate';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

import 'package:classes_app/screens/assignments/body/BodyDetail.dart';
import 'package:classes_app/screens/image_zoom/ImageZoom.dart';
import 'package:classes_app/screens/assignments/ViewDocument.dart';

import 'package:classes_app/models/AssignmentModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';
import 'package:classes_app/utils/CallApi.dart';

class AssignmentDetail extends StatefulWidget {
  AssignmentDetail({Key key, this.assignmentModel}) : super(key: key);

  final AssignmentModel assignmentModel;

  @override
  _AssignmentDetailState createState() => _AssignmentDetailState();
}

class _AssignmentDetailState extends State<AssignmentDetail> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPrefs;

  var _isLoading = true;

  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();

  String _extension;
  String _fileName;
  var isFirsTime = true;

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();
    initDownload();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
    });
  }

  initDownload() async {
    _bindBackgroundIsolate();

    //await FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;
    //_prepare();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  TargetPlatform platform;

  _downloadClick() {
    if (widget.assignmentModel.assignment_file != null &&
        widget.assignmentModel.assignment_file.isNotEmpty) {
      String fileUrl = widget.assignmentModel.assignment_file.substring(1);

      if (fileUrl[0] == ".") {
        fileUrl = fileUrl.substring(1);
      }
      String finalUrl = BaseURL.BASE_URL + fileUrl;
      String filename = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);

      print(finalUrl);
      print(filename);

      _prepare(finalUrl, filename);
    } else if (widget.assignmentModel.assignment_stud_file != null &&
        widget.assignmentModel.assignment_stud_file.isNotEmpty) {
      var fileUrl = widget.assignmentModel.assignment_stud_file;

      if (fileUrl[0] == ".") {
        fileUrl = fileUrl.substring(1);
      }
      String finalUrl = BaseURL.BASE_URL + fileUrl;
      String filename = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);

      print(finalUrl);
      print(filename);

      _prepare(finalUrl, filename);
    }
  }

  _submitClick() {
    if (sharedPrefs.getInt(BaseURL.KEY_LOGIN_TYPE) == 1) {
      _checkPermission().then((isGranted) {
        _openFileExplorer(FileType.any, false).then((filePath) {
          print("pickupPath:" + filePath);
          if (filePath.isNotEmpty) {
            _makeSubmitAssignments(
                context, widget.assignmentModel.assign_id, filePath);
          }
        });
      });
    }
  }

  _viewClick() {
    String finalUrl = "";
    String filename = "";

    if (widget.assignmentModel.assignment_file != null &&
        widget.assignmentModel.assignment_file.isNotEmpty) {
      String fileUrl = widget.assignmentModel.assignment_file.substring(1);
      if (fileUrl[0] == ".") {
        fileUrl = fileUrl.substring(1);
      }
      finalUrl = BaseURL.BASE_URL + fileUrl;
      filename = finalUrl.substring(finalUrl.lastIndexOf("/") + 1);
    } else if (widget.assignmentModel.assignment_stud_file != null &&
        widget.assignmentModel.assignment_stud_file.isNotEmpty) {
      String fileUrl = widget.assignmentModel.assignment_stud_file;
      if (fileUrl[0] == ".") {
        fileUrl = fileUrl.substring(1);
      }
      finalUrl = BaseURL.BASE_URL + fileUrl;
      filename = finalUrl.substring(finalUrl.lastIndexOf("/") + 1);
    }

    if (finalUrl.isNotEmpty) {
      if (filename == ".png" || filename == ".jpg" || filename == ".jpeg") {
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 400),
                pageBuilder: (_, __, ___) => ImageZoom(
                      heroTag: "note_",
                      imagePath: finalUrl,
                    )));
      } else {
        Future.delayed(Duration.zero, () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewDocument(
                        fileUrl: finalUrl,
                        title: widget.assignmentModel.assign_title,
                      )));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;

    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(widget.assignmentModel.assign_title ?? ""),
          backgroundColor: ColorsInt.colorPrimary,
        ),
        body: new BodyDetail(
          assignmentModel: widget.assignmentModel,
          downloadClick: () => _downloadClick(),
          submitClick: () => _submitClick(),
          viewClick: () => _viewClick(),
        ));
  }

  _makeSubmitAssignments(
      BuildContext context, String assignment_id, String filePath) async {
    var url = BaseURL.SUBMIT_ASSIGNMENTS_URL;

    String mimeType = mime(filePath.split('/').last);

    FormData formData = new FormData.fromMap({
      "student_id": "${sharedPrefs.getString(BaseURL.KEY_USER_ID)}",
      "assign_id": "$assignment_id",
      "subassignment_file": await MultipartFile.fromFile(filePath,
          filename: _fileName,
          contentType:
              MediaType(mimeType.split("/").first, mimeType.split("/").last))
    });

    CallApi().postFile(context, url, formData, true).then((response) {
      _displaySnackBar(context,
          AppLocalizations.of(context).translate("assignment_submitted"));
      Navigator.pop(context, "true");
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<Null> _prepare(String fileUrl, String fileName) async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    _tasks.add(_TaskInfo(name: fileName, link: fileUrl));
    _items.add(_ItemHolder(name: 'Images'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    _permissionReady = await _checkPermission();

    _localPath = await _findLocalPath();

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    _requestDownload(_tasks[0]);
  }

  void _requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  Future<String> _findLocalPath() async {
    final directory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    if (platform == TargetPlatform.android) {
      return "/sdcard/download/${AppLocalizations.of(context).translate("app_name")}";
    } else {
      return directory.path;
    }
  }

  Future<String> _openFileExplorer(
      FileType _pickingType, bool _multiPick) async {
    List<String> extenstionList = ['jpg', 'pdf', 'doc', 'png'];

    String _path;
    Map<String, String> _paths;

    try {
      if (_multiPick) {
        _path = null;
        _paths = await FilePicker.getMultiFilePath(
            type: FileType.custom, allowedExtensions: extenstionList);
      } else {
        _path = null;
        _path = await FilePicker.getFilePath(
            type: FileType.custom, allowedExtensions: extenstionList);
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted)
      setState(() {
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    return _path;
  }

  _displaySnackBar(BuildContext context, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

class _TaskInfo {
  final String name;
  final String link;
  String taskId;

  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
}
