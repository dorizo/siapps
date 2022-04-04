import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:classes_app/screens/image_zoom/ImageZoom.dart';
import 'package:classes_app/models/AnnouncementModel.dart';

import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/theme/Color.dart';
import 'package:classes_app/utils/DateFormatter.dart';

class BodyAnnouncement extends StatelessWidget {
  BodyAnnouncement({Key key, this.announcementModelList}) : super(key: key);

  List<AnnouncementModel> announcementModelList;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      shrinkWrap: false,
      itemCount: announcementModelList.length,
      itemBuilder: (context, index) {
        final AnnouncementModel announcementModel =
            announcementModelList[index];
        return new Container(
          margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorsInt.colorGray,
              width: 1.0,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: ColorsInt.colorGray,
                blurRadius: 1.0,
                offset: new Offset(0.0, 0.0),
              ),
            ],
          ),
          child: new Container(
            width: double.infinity,
            /*padding: EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),*/
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Visibility(
                  visible: (announcementModel.image != null &&
                      announcementModel.image.isNotEmpty),
                  child: new InkWell(
                    child: new ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14.0),
                          topRight: Radius.circular(14.0)),
                      child: new Hero(
                        tag: "noti_${announcementModel.id}",
                        child: new Image.network(
                          BaseURL.IMG_ANNOUNCEMENT + announcementModel.image,
                          fit: BoxFit.cover,
                          height: 150.0,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 400),
                              pageBuilder: (_, __, ___) => ImageZoom(
                                    heroTag: "noti_${announcementModel.id}",
                                    imagePath: BaseURL.IMG_ANNOUNCEMENT +
                                        announcementModel.image,
                                  )));
                    },
                  ),
                ),
                new Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                    child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            announcementModel.message ?? "",
                            style: TextStyle(
                                fontFamily: "regular",
                                fontSize: 16.0,
                                color: ColorsInt.colorText),
                          ),
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text(
                            DateFormatter.getConvetedDateTime(
                                context, announcementModel.created_at, 1),
                            style: TextStyle(
                                fontFamily: "regular",
                                fontSize: 10.0,
                                color: ColorsInt.colorCyan),
                          ),
                        ])),
              ],
            ),
          ),
        );
      },
    );
  }
}
