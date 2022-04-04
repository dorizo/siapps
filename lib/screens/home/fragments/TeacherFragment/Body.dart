import 'package:classes_app/config/BaseURL.dart';
import 'package:flutter/material.dart';

import 'package:classes_app/screens/teacher_detail/TeacherDetail.dart';
import 'package:classes_app/models/TeacherModel.dart';

import 'package:classes_app/theme/Color.dart';
import 'package:flutter/rendering.dart';

class Body extends StatelessWidget {
  Body({Key key, @required this.teacherModelList}) : super(key: key);

  List<TeacherModel> teacherModelList;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: (teacherModelList != null) ? teacherModelList.length : 0,
      itemBuilder: (context, index) {
        final teacherModel = teacherModelList[index];

        return new InkWell(
          child: new Container(
            margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorsInt.colorGray,
                width: 1.0,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
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
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Hero(
                    tag: "teacher_${teacherModel.teacher_id}",
                    child: new CircleAvatar(
                      radius: 25.0,
                      backgroundImage: new NetworkImage(
                          "${BaseURL.IMG_TEACHER + teacherModel.teacher_photo}"),
                      backgroundColor: ColorsInt.colorGray,
                    ),
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  new Expanded(
                    child: new Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          teacherModel.teacher_fullname ?? "",
                          style: TextStyle(
                            fontFamily: "regular",
                            fontSize: 18.0,
                            color: ColorsInt.colorBlack,
                          ),
                        ),
                        new Text(
                          teacherModel.teacher_qualification ?? "",
                          style: TextStyle(
                            fontFamily: "regular",
                            fontSize: 12.0,
                            color: ColorsInt.colorBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeacherDetail(
                          teacherModel: teacherModel,
                        )));*/
            Navigator.push(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 400),
                    pageBuilder: (_, __, ___) => TeacherDetail(
                          teacherModel: teacherModel,
                        )));
          },
        );
      },
    );
  }
}
