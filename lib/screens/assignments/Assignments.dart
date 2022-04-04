import 'package:flutter/material.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'dart:io' show Platform;
import 'dart:isolate';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:classes_app/screens/assignments/body/Body.dart';
import 'package:classes_app/screens/assignments/ViewDocument.dart';
import 'package:classes_app/screens/assignments/AssignmentDetail.dart';

import 'package:classes_app/models/AssignmentModel.dart';
import 'package:classes_app/models/BatchModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/config/globals.dart' as globles;
import 'package:classes_app/utils/CallApi.dart';
import 'package:classes_app/utils/DateFormatter.dart';
import 'package:classes_app/utils/app_localizations.dart';

class Assignments extends StatefulWidget {
  static String textdata = "";

  @override
  _AssigmentsState createState() => _AssigmentsState();
}

/*void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  print(
      'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
  //if (showProgressNotification) {
  if (flutterLocalNotificationsPlugin == null) {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  }
  _showProgressNotification(status.value, progress);
  //}
}*/

Future<void> _showProgressNotification(
    int notificationID, String title, int progress) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'progress channel', 'progress channel', 'progress channel description',
      channelShowBadge: false,
      importance: Importance.Max,
      priority: Priority.High,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      notificationID,
      "$title Downloading progress",
      globles.notificationDetail,
      platformChannelSpecifics,
      payload: 'item x');

  if (progress >= 100) {
    await flutterLocalNotificationsPlugin.cancel(notificationID);
  }
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

FlutterLocalNotificationsPlugin initNotification() {
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);

  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);
}

Future onSelectNotification(String payload) async {
  if (payload != null) {
    debugPrint('notification payload: ' + payload);
  }
}

void setNotificationDetail(String title) {
  print(title);
  globles.notificationTitle = title;
  globles.notificationDetail = title;
}

void showProgressDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Column(
            children: <Widget>[new Text("SDFSDF")],
          ),
        );
      });
}

class _AssigmentsState extends State<Assignments> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;
  SharedPreferences sharedPrefs;

  static DateTime now = new DateTime.now();

  int _selectedMonth = now.month;
  String _selectedYear = now.year.toString();
  String _selectedClassesID = "";
  String _selectedClasses = "";
  List<String> _monthList = [];
  List<String> _yearList = [];
  List<String> _classList = [];
  List<BatchModel> _batchesModelList = [];
  List<AssignmentModel> _assignmentModelList = [];
  bool _showFilter = false;

  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  bool _isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();

  bool _loadingPath = false;

  //String _path;
  //Map<String, String> _paths;
  //List<File> _files;
  String _extension;
  String _fileName;
  var isFirsTime = true;

  //static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  /*static void downloadCallback(String id, DownloadTaskStatus status,
      int progress, String filename) async {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    print("title2" + Assignments.textdata);
    _showProgressNotification(status.value, Assignments.textdata, progress);
  }*/

  @override
  void initState() {
    super.initState();

    initDownload();
    initNotification();

    setState(() {
      _yearList.clear();
      for (int i = 2016; i <= now.year; i++) {
        _yearList.add(new DateFormat('yyyy').format(new DateTime(i, 1)));
      }
      _monthList.clear();
      for (int i = 1; i <= 12; i++) {
        _monthList.add(new DateFormat('MMMM', globles.lang)
            .format(new DateTime(now.year, i, 1)));
      }
    });

    _classList.clear();

    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      if (sharedPrefs.containsKey("batches_list")) {
        final List studentList =
            jsonDecode(sharedPrefs.getString("batches_list"));
        _batchesModelList.addAll(
            studentList.map((val) => BatchModel.fromJson(val)).toList());
        if (_batchesModelList.length > 0) {
          _selectedClasses = _batchesModelList[0].batch_name;
          _selectedClassesID = _batchesModelList[0].batch_id;
          for (int i = 0; i < _batchesModelList.length; i++) {
            _classList.add(_batchesModelList[i].batch_name);
          }
        }
        _makeGetAssignments(context);
      }
    });
  }

  @override
  void didUpdateWidget(Assignments oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  initDownload() async {
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;
    //_prepare();
  }

  showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '9832564',
        AppLocalizations.of(context).translate("app_name"),
        AppLocalizations.of(context).translate("app_name"),
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      2,
      'New Post',
      'How to Show Notification in Flutter',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
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

      /*final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
        _showProgressNotification(status.value, task.name, progress);
      }*/
    });
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void _gotoDetail(AssignmentModel assignmentModel) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AssignmentDetail(
                  /*fileUrl: finalUrl,
                          title: assignmentModel.assign_title,*/
                  assignmentModel: assignmentModel,
                )));
    if (result != null) {
      setState(() {
        isFirsTime = true;
      });
      _makeGetAssignments(context);
    }
  }

  TargetPlatform platform;

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;

    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("assignments")),
        backgroundColor: ColorsInt.colorPrimary,
        actions: <Widget>[
          new InkWell(
            child: new Image.asset("assets/images/ic_filter.png"),
            onTap: () {
              setState(() {
                _showFilter = !_showFilter;
              });
            },
          ),
        ],
      ),
      body: new Body(
        showFilter: _showFilter,
        selectedMonth: _selectedMonth,
        selectedYear: _selectedYear,
        selectedClasses: _selectedClasses,
        monthList: _monthList,
        yearList: _yearList,
        classList: _classList,
        assignmentModelList: _assignmentModelList,
        onMonthSelected: (int newValue) {
          setState(() {
            var isNew = (_selectedYear != newValue);
            _selectedMonth = newValue;
            if (isNew) {
              _makeGetAssignments(context);
            }
          });
        },
        onYearSelected: (String newValue) {
          setState(() {
            var isNew = (_selectedYear != newValue);
            _selectedYear = newValue;
            if (isNew) {
              _makeGetAssignments(context);
            }
          });
        },
        onClassesSelected: (String newValue) {
          setState(() {
            var selectedBatch = _getBatchDetailByName(newValue);
            if (selectedBatch != null) {
              var isNew = (_selectedClasses != newValue);
              _selectedClasses = newValue;
              _selectedClassesID = selectedBatch.batch_id;
              if (isNew) {
                _makeGetAssignments(context);
              }
            }
          });
        },
        onViewClick: (AssignmentModel assignmentModel) =>
            _gotoDetail(assignmentModel),
        onSubmitClick: (AssignmentModel assignmentModel) {
          if (sharedPrefs.getInt(BaseURL.KEY_LOGIN_TYPE) == 1) {
            _checkPermission().then((isGranted) {
              _openFileExplorer(FileType.any, false).then((filePath) {
                print("pickupPath:" + filePath);
                if (filePath.isNotEmpty) {
                  _makeSubmitAssignments(
                      context, assignmentModel.assign_id, filePath);
                }
              });
            });
          }
        },
      ),
    );
  }

  BatchModel _getBatchDetailByName(String name) {
    for (BatchModel batchModel in _batchesModelList) {
      if (batchModel.batch_name == name) {
        return batchModel;
      }
    }
    return null;
  }

  _makeGetAssignments(BuildContext context) {
    var url = BaseURL.GET_ASSIGNMENTS_LIST_URL;
    var map = new Map<String, String>();
    map['student_id'] = sharedPrefs.getString(BaseURL.KEY_USER_ID);
    map['month'] = (isFirsTime)
        ? ""
        : DateFormatter.getConvetedDate(
            "${now.year}-${_selectedMonth.toString()}-1", 1);
    map['year'] = (isFirsTime) ? "" : _selectedYear;
    map['batch'] = (isFirsTime) ? "" : _selectedClassesID;

    setState(() {
      if (_assignmentModelList.length > 0) {
        _assignmentModelList.clear();
      }
      isFirsTime = false;
    });

    CallApi().post(context, url, map, true).then((response) {
      final List dataJson = json.decode(response);
      setState(() {
        if (_assignmentModelList.length > 0) {
          _assignmentModelList.clear();
        }
        _assignmentModelList.addAll(
            dataJson.map((val) => AssignmentModel.fromJson(val)).toList());
      });
    }, onError: (error) {
      _displaySnackBar(context, error.toString());
    });
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
      setState(() {
        isFirsTime = true;
      });
      _makeGetAssignments(context);
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

  Future<Null> _prepare(
      String fileUrl, String fileName, AssignmentModel assignmentsModel) async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    /*_showNotification();
    showNotificationWithDefaultSound();*/

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
    //_localPath = (await _findLocalPath()) + '/Download/${Strings.app_name}';
    //_localPath = (await _findLocalPath()) + Platform.pathSeparator + Strings.app_name;

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    final file = File("$_localPath/$fileName");
    file.exists().then((isExisted) {
      if (isExisted) {
        print("static" + Assignments.textdata);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewDocument(
                      //fileUrl: "$_localPath/$fileName",
                      fileUrl: fileUrl,
                      title: assignmentsModel.assign_title,
                    )));
      } else {
        print("sdsdf" + fileName);
        Assignments.textdata = "hi";
        //notificationTitle = fileName;
        setNotificationDetail(fileName);
        _requestDownload(_tasks[0]);
      }
    });
  }

  void _requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  Future<String> _findLocalPath() async {
    print(Platform.operatingSystem);
    print("1" + (await getApplicationDocumentsDirectory()).path);
    print("2" + (await getExternalStorageDirectory()).path);
    print("3" +
        (await getExternalStorageDirectories(
                type: StorageDirectory.downloads))[0]
            .path);
    print("4" + (await ExtStorage.getExternalStorageDirectory()));

    /*final directory = Platform.isIOS
        ? (await getApplicationDocumentsDirectory()).path
        : (await ExtStorage.getExternalStorageDirectory());*/

    final directory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    if (platform == TargetPlatform.android) {
      return "/sdcard/download/${AppLocalizations.of(context).translate("app_name")}";
    } else {
      return directory.path;
    }
    // return directory; //.path;
  }

  Future<String> _openFileExplorer(
      FileType _pickingType, bool _multiPick) async {
    setState(() => _loadingPath = true);
    List<String> extenstionList = ['jpg', 'pdf', 'doc', 'png'];

    String _path;
    Map<String, String> _paths;

    try {
      if (_multiPick) {
        _path = null;
        /*_paths = await FilePicker.getMultiFilePath(
              type: _pickingType, extenstionList);*/
        _paths = await FilePicker.getMultiFilePath(
            type: FileType.custom, allowedExtensions: extenstionList);
      } else {
        _path = null;
        /*_path = await FilePicker.getFilePath(
              type: _pickingType, extenstionList);*/
        _path = await FilePicker.getFilePath(
            type: FileType.custom, allowedExtensions: extenstionList);
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted)
      setState(() {
        _loadingPath = false;
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
