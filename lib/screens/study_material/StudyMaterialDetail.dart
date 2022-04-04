// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:io' show Platform;
// import 'dart:isolate';
// import 'dart:ui';
// import 'dart:io';
// import 'dart:convert';
// import 'package:ext_storage/ext_storage.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// import 'package:classes_app/screens/study_material/bodys/BodyStudyMaterialDetail.dart';
// import 'package:classes_app/screens/assignments/ViewDocument.dart';

// import 'package:classes_app/models/StudyMaterialModel.dart';

// import 'package:classes_app/config/BaseURL.dart';
// import 'package:classes_app/theme/Color.dart';
// import 'package:classes_app/utils/app_localizations.dart';

// class StudyMaterialDetail extends StatefulWidget {
//   StudyMaterialDetail({Key key, @required this.studyMaterialModel})
//       : super(key: key);

//   StudyMaterialModel studyMaterialModel;

//   @override
//   _StudyMaterialDetailState createState() =>
//       _StudyMaterialDetailState(studyMaterialModel);
// }

// class _StudyMaterialDetailState extends State<StudyMaterialDetail> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   VideoPlayerController _videoPlayerController;
//   static ChewieController _chewieController;
//   Chewie _playerWidget;

//   YoutubePlayerController _youtubePlayerController;

//   StudyMaterialModel _studyMaterialModel;

//   _StudyMaterialDetailState(this._studyMaterialModel);

//   var showVideo = false;
//   String videoType = "";
//   String urlVimeo = "test video";
//   String imageUrl;

//   List<double> pastWebHeights = [];
//   double _webHeight = 100.0;

//   //WebViewController _controller;

//   InAppWebViewController _controller;

//   var _isLoading = true;

//   List<_TaskInfo> _tasks;
//   List<_ItemHolder> _items;
//   bool _permissionReady;
//   String _localPath;
//   ReceivePort _port = ReceivePort();

//   @override
//   void initState() {
//     super.initState();

//     initDownload();

//     var thumbIcon = "assets/images/ic_doc.png";
//     var thumbVisible = true;
//     if (_studyMaterialModel.type == "doc") {
//       thumbIcon = "assets/images/ic_doc.png";
//       thumbVisible = true;
//     } else if (_studyMaterialModel.type == "video") {
//       thumbIcon = "assets/images/ic_video.png";
//       thumbVisible = true;
//       videoType = _studyMaterialModel.video_type ?? "";
//       if (_studyMaterialModel.video_url != null &&
//           _studyMaterialModel.video_url.isNotEmpty) {
//         showVideo = true;
//       }
//     } else if (_studyMaterialModel.type == "desc") {
//       thumbIcon = "assets/images/ic_txt.png";
//       thumbVisible = false;
//     } else if (_studyMaterialModel.type == "image") {
//       thumbIcon = "assets/images/ic_image.png";
//       thumbVisible = false;
//       String fileUrl = widget.studyMaterialModel.file ?? "";
//       if (fileUrl != null && fileUrl.isNotEmpty) {
//         if (fileUrl[0] == ".") {
//           fileUrl = fileUrl.substring(1);
//         }
//         imageUrl = BaseURL.BASE_URL + fileUrl;
//       }
//     }

//     if (showVideo && (videoType.isNotEmpty && videoType == "file")) {
//       String videourl = (_studyMaterialModel.file != null &&
//               _studyMaterialModel.file.isNotEmpty)
//           ? _studyMaterialModel.file.substring(1)
//           : "";

//       _videoPlayerController =
//           VideoPlayerController.network(BaseURL.BASE_URL + videourl);

//       _chewieController = ChewieController(
//         videoPlayerController: _videoPlayerController,
//         aspectRatio: 3 / 2,
//         autoPlay: true,
//         looping: false,
//       );

//       _playerWidget = Chewie(
//         controller: _chewieController,
//       );
//     } else if (showVideo && (videoType.isNotEmpty && videoType == "youtube")) {
//       String youtubeid =
//           ((showVideo && (videoType.isNotEmpty && videoType == "youtube")) &&
//                   (_studyMaterialModel.video_url != null &&
//                       _studyMaterialModel.video_url.isNotEmpty))
//               ? YoutubePlayer.convertUrlToId(_studyMaterialModel.video_url)
//               : "test video";

//       _youtubePlayerController = YoutubePlayerController(
//         initialVideoId: youtubeid,
//         flags: YoutubePlayerFlags(
//           autoPlay: true,
//           mute: false,
//         ),
//       );
//     } else if (showVideo && (videoType.isNotEmpty && videoType == "youtube")) {
//       urlVimeo =
//           ((showVideo && (videoType.isNotEmpty && videoType == "vimeo")) &&
//                   (_studyMaterialModel.video_url != null &&
//                       _studyMaterialModel.video_url.isNotEmpty))
//               ? _studyMaterialModel.video_url
//               : "test video";
//     }
//   }

//   initDownload() async {
//     _bindBackgroundIsolate();

//     FlutterDownloader.registerCallback(downloadCallback);

//     _isLoading = true;
//     _permissionReady = false;
//     //_prepare();
//   }

//   _startDownload() {
//     String fileUrl = widget.studyMaterialModel.file ?? "";
//     if (fileUrl != null && fileUrl.isNotEmpty) {
//       if (fileUrl[0] == ".") {
//         fileUrl = fileUrl.substring(1);
//       }
//       String finalUrl = BaseURL.BASE_URL + fileUrl;
//       String filename = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
//       final file = File("$_localPath/$filename");
//       print("fileFullUrl::$finalUrl");
//       file.exists().then((isExisted) {
//         if (!isExisted) {
//           _prepare(finalUrl, filename);
//         }
//       });
//     }
//   }

//   _startView() {
//     String fileUrl = widget.studyMaterialModel.file ?? "";
//     if (fileUrl != null && fileUrl.isNotEmpty) {
//       if (fileUrl[0] == ".") {
//         fileUrl = fileUrl.substring(1);
//       }
//       String finalUrl = BaseURL.BASE_URL + fileUrl;
//       String filename = finalUrl.substring(finalUrl.lastIndexOf("/") + 1);
//       if (filename == ".png" || filename == ".jpg" || filename == ".jpeg") {
//         /*Navigator.push(
//           context,
//           PageRouteBuilder(
//               transitionDuration: Duration(milliseconds: 400),
//               pageBuilder: (_, __, ___) => ImageZoom(
//                 heroTag: "note_",
//                 imagePath: finalUrl,
//               )));*/
//       } else {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ViewDocument(
//                       fileUrl: finalUrl,
//                       title: widget.studyMaterialModel.title,
//                     )));
//       }
//     }
//   }

//   _setWebHeight(double height) {
//     print("height::$height");
//     setState(() {
//       _webHeight = height;
//       pastWebHeights.add(height);
//     });
//   }

//   _setWebController(InAppWebViewController controller) {
//     /*controller.loadData(
//         "<html><body>" + widget.studyMaterialModel.description ??
//             "" + "</body></html>",
//         mimeType: 'text/html',
//         encoding: Encoding.getByName('utf-8').toString());*/
//     setState(() {
//       _controller = controller;
//     });
//   }

//   Future<bool> _onWillPop() async {
//     if (_controller != null) {
//       if (await _controller.canGoBack()) {
//         _controller.goBack();
//         setState(() {
//           pastWebHeights.removeLast();
//           _webHeight = pastWebHeights[pastWebHeights.length - 1];
//         });
//       } else {
//         return true;
//       }
//     } else {
//       return true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     platform = Theme.of(context).platform;

//     return new WillPopScope(
//         onWillPop: _onWillPop,
//         child: new Scaffold(
//           key: _scaffoldKey,
//           appBar: new AppBar(
//             title: new Text(
//                 AppLocalizations.of(context).translate("study_material")),
//             backgroundColor: ColorsInt.colorPrimary,
//           ),
//           body: new ListView(
//               /*crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,*/
//               shrinkWrap: false,
//               children: <Widget>[
//                 new Visibility(
//                     visible: (showVideo &&
//                         (videoType.isNotEmpty && videoType == "file")),
//                     child: new Container(
//                       width: double.infinity,
//                       height: 200.0,
//                       child: _playerWidget,
//                     )),
//                 new Visibility(
//                     visible: (showVideo &&
//                         (videoType.isNotEmpty && videoType == "youtube")),
//                     child: new Container(
//                       width: double.infinity,
//                       height: 200.0,
//                       child: new YoutubePlayer(
//                         controller: _youtubePlayerController,
//                         showVideoProgressIndicator: true,
//                         progressColors: new ProgressBarColors(
//                             playedColor: Colors.red,
//                             handleColor: Colors.redAccent),
//                         onReady: () {
//                           //_youtubePlayerController.addListener(listener)
//                         },
//                       ),
//                     )),
//                 new Visibility(
//                     visible: (showVideo &&
//                         (videoType.isNotEmpty && videoType == "vimeo")),
//                     child: new Container(
//                       width: double.infinity,
//                       height: 200.0,
//                       /*https://player.vimeo.com/video/358296442*/
//                       child:
//                           /*new WebView(
//                         initialUrl: Uri.dataFromString(
//                                 '<html><body><iframe src="$urlVimeo" width="100%" height="100%" frameborder="0" title="My video" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></body></html>',
//                                 mimeType: 'text/html')
//                             .toString(), //urlVimeo,
//                         javascriptMode: JavascriptMode.unrestricted,
//                         onWebViewCreated:
//                             (WebViewController webViewController) {
//                           //_controller.complete(webViewController);
//                         },
//                       )*/
//                           new InAppWebView(
//                         initialUrl: Uri.dataFromString(
//                                 '<html><body><iframe src="$urlVimeo" width="100%" height="100%" frameborder="0" title="My video" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></body></html>',
//                                 mimeType: 'text/html')
//                             .toString(),
//                         initialOptions: new InAppWebViewGroupOptions(
//                             crossPlatform: InAppWebViewOptions(
//                                 javaScriptEnabled: true, supportZoom: false)),
//                       ),
//                     )),
//                 new Visibility(
//                     visible: (widget.studyMaterialModel.type != null &&
//                         widget.studyMaterialModel.type == "image"),
//                     child: new Image.network(imageUrl ?? "")),
//                 new BodyStudyMaterialDetail(
//                   studyMaterialModel: _studyMaterialModel,
//                   controller: _controller,
//                   webHeight: _webHeight,
//                   setWebHeight: (height) => _setWebHeight(height),
//                   setWebController: (controller) =>
//                       _setWebController(controller),
//                   startDownload: () => _startDownload(),
//                   startView: () => _startView(),
//                 ),
//               ]),
//         ));
//   }

//   @override
//   void dispose() {
//     if (_videoPlayerController != null) {
//       _videoPlayerController.dispose();
//     }
//     if (_chewieController != null) {
//       _chewieController.dispose();
//     }
//     _unbindBackgroundIsolate();
//     super.dispose();
//   }

//   void _unbindBackgroundIsolate() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//   }

//   void _bindBackgroundIsolate() {
//     bool isSuccess = IsolateNameServer.registerPortWithName(
//         _port.sendPort, 'downloader_send_port');
//     if (!isSuccess) {
//       _unbindBackgroundIsolate();
//       _bindBackgroundIsolate();
//       return;
//     }
//     _port.listen((dynamic data) {
//       print('UI Isolate Callback: $data');
//       String id = data[0];
//       DownloadTaskStatus status = data[1];
//       int progress = data[2];

//       final task = _tasks?.firstWhere((task) => task.taskId == id);
//       if (task != null) {
//         setState(() {
//           task.status = status;
//           task.progress = progress;
//         });
//         //_showProgressNotification(status.value, task.name, progress);
//       }
//     });
//   }

//   static void downloadCallback(
//       String id, DownloadTaskStatus status, int progress) {
//     print(
//         'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
//     final SendPort send =
//         IsolateNameServer.lookupPortByName('downloader_send_port');
//     send.send([id, status, progress]);
//   }

//   TargetPlatform platform;

//   Future<bool> _checkPermission() async {
//     if (platform == TargetPlatform.android) {
//       PermissionStatus permission = await PermissionHandler()
//           .checkPermissionStatus(PermissionGroup.storage);
//       if (permission != PermissionStatus.granted) {
//         Map<PermissionGroup, PermissionStatus> permissions =
//             await PermissionHandler()
//                 .requestPermissions([PermissionGroup.storage]);
//         if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
//           return true;
//         }
//       } else {
//         return true;
//       }
//     } else {
//       return true;
//     }
//     return false;
//   }

//   Future<Null> _prepare(String fileUrl, String fileName) async {
//     final tasks = await FlutterDownloader.loadTasks();

//     int count = 0;
//     _tasks = [];
//     _items = [];

//     /*_showNotification();
//     showNotificationWithDefaultSound();*/

//     _tasks.add(_TaskInfo(name: fileName, link: fileUrl));
//     _items.add(_ItemHolder(name: 'Images'));
//     for (int i = count; i < _tasks.length; i++) {
//       _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
//       count++;
//     }

//     tasks?.forEach((task) {
//       for (_TaskInfo info in _tasks) {
//         if (info.link == task.url) {
//           info.taskId = task.taskId;
//           info.status = task.status;
//           info.progress = task.progress;
//         }
//       }
//     });

//     _permissionReady = await _checkPermission();

//     _localPath = await _findLocalPath();
//     //_localPath = (await _findLocalPath()) + '/Download/${Strings.app_name}';
//     //_localPath = (await _findLocalPath()) + Platform.pathSeparator + Strings.app_name;

//     final savedDir = Directory(_localPath);
//     bool hasExisted = await savedDir.exists();
//     if (!hasExisted) {
//       savedDir.create();
//     }

//     print("sdsdf" + fileName);
//     _requestDownload(_tasks[0]);
//   }

//   void _requestDownload(_TaskInfo task) async {
//     task.taskId = await FlutterDownloader.enqueue(
//         url: task.link,
//         headers: {"auth": "test_for_sql_encoding"},
//         savedDir: _localPath,
//         showNotification: true,
//         openFileFromNotification: true);
//   }

//   Future<String> _findLocalPath() async {
//     final directory = platform == TargetPlatform.android
//         ? await getExternalStorageDirectory()
//         : await getApplicationDocumentsDirectory();

//     if (platform == TargetPlatform.android) {
//       return "/sdcard/download/${AppLocalizations.of(context).translate("app_name")}";
//     } else {
//       return directory.path;
//     }
//   }
// }

// class _TaskInfo {
//   final String name;
//   final String link;
//   String taskId;

//   int progress = 0;
//   DownloadTaskStatus status = DownloadTaskStatus.undefined;

//   _TaskInfo({this.name, this.link});
// }

// class _ItemHolder {
//   final String name;
//   final _TaskInfo task;

//   _ItemHolder({this.name, this.task});
// }
