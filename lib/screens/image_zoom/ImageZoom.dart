import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'package:classes_app/theme/Color.dart';

class ImageZoom extends StatefulWidget {
  ImageZoom({Key key, this.heroTag, @required this.imagePath})
      : super(key: key);

  String heroTag;
  String imagePath;

  @override
  _ImageZoomState createState() => _ImageZoomState();
}

class _ImageZoomState extends State<ImageZoom> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: null,
      body: new Stack(
        children: <Widget>[
          Container(
            child: new Hero(
              tag: widget.heroTag,
              child: PhotoView(
                imageProvider: NetworkImage(widget.imagePath),
                backgroundDecoration: BoxDecoration(
                  color: ColorsInt.colorWhite,
                ),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 1.8,
                initialScale: PhotoViewComputedScale.contained * 1.1,
              ),
            ),
          ),
          new Positioned(
            top: 30.0,
            right: 10.0,
            child: new InkWell(
              child: Icon(
                Icons.close,
                size: 50.0,
              ),
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
