import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'dart:isolate';
import 'dart:ui';
import 'package:permission_handler/permission_handler.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';

import 'package:classes_app/components/CustomLoader.dart';

import 'package:classes_app/config/globals.dart' as globles;

import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/app_localizations.dart';

class ViewDocument extends StatefulWidget {
  ViewDocument({Key key, @required this.fileUrl, @required this.title})
      : super(key: key);

  final String fileUrl, title;

  @override
  _ViewDocumentState createState() => _ViewDocumentState(fileUrl, title);
}

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

class _ViewDocumentState extends State<ViewDocument> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String TAG = "ViewDocument: ";
  String _fileUrl, _title;

  _ViewDocumentState(this._fileUrl, this._title);

  WebViewController _controller;

  String documentUrl = "";

  var _isLoading = true;

  bool loadingTypeImage = false;
  File file;

  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    initDownload();
    initNotification();

    /*file = File(_fileUrl);
    file.exists();*/

    print("viewPath:$_fileUrl");

    int lastDot = _fileUrl.lastIndexOf('.', _fileUrl.length - 1);
    if (lastDot != -1) {
      String extension = _fileUrl.substring(lastDot + 1);
      if (extension == "jpg" || extension == "png" || extension == "jpeg") {
        loadingTypeImage = true;
      } else {
        loadingTypeImage = false;
      }
    }
  }

  initDownload() async {
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

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
        //_showProgressNotification(status.value, task.name, progress);
      }
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

  Future<bool> _refresh() async {
    if (_controller != null) {
      setState(() {
        _isLoading = true;
      });
      _controller
          .loadUrl("http://docs.google.com/gview?embedded=true&url=$_fileUrl");
    }
    return true;
  }

  TargetPlatform platform;

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;

    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(_title),
        backgroundColor: ColorsInt.colorPrimary,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.refresh,
              color: ColorsInt.colorWhite,
              size: 35,
            ),
            onPressed: () => _refresh(),
          ),
          /*new InkWell(
            child: new Image.asset(
              "assets/images/ic_download.png",
            ),
            onTap: () {
              String filename =
                  _fileUrl.substring(_fileUrl.lastIndexOf("/") + 1);
              final file = File("$_localPath/$filename");
              file.exists().then((isExisted) {
                if (!isExisted) {
                  _prepare(_fileUrl, filename);
                }
              });
            },
          ),*/
        ],
      ),
      body: loadingTypeImage
          ? new Image.network(_fileUrl)
          : new Stack(
              children: [
                new WebView(
                  initialUrl:
                      "http://docs.google.com/gview?embedded=true&url=$_fileUrl",
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    setState(() {
                      _controller = webViewController;
                    });
                    //_showLoading(context);
                    print("onWebViewCreated");
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  onPageFinished: (String url) {
                    print("onPageFinished:$url");
                    setState(() {
                      _isLoading = false;
                    });
                    //_showLoading(context);
                  },
                ),
                new Visibility(
                  visible: _isLoading,
                  child: new Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
    );
  }

  _showLoading(BuildContext context) {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new CustomLoader();
          }).then((val) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      if (_isLoading) {
        Navigator.pop(context);
      }
    }
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

    print("sdsdf" + fileName);
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
