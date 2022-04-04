import 'package:classes_app/screens/assignments/WebviewLink.dart';
import 'package:classes_app/screens/report/report.dart';
import 'package:flutter/widgets.dart';

import 'package:classes_app/screens/login/Login.dart';
import 'package:classes_app/screens/parent_login/ParentLogin.dart';
import 'package:classes_app/screens/home/Home.dart';
import 'package:classes_app/screens/attendance/Attendance.dart';
import 'package:classes_app/screens/assignments/Assignments.dart';
import 'package:classes_app/screens/study_material/StudyMaterial.dart';
import 'package:classes_app/screens/fees/Fees.dart';
import 'package:classes_app/screens/exams/Exams.dart';
import 'package:classes_app/screens/exams/ExamStart.dart';
import 'package:classes_app/screens/exams/ExamFinished.dart';
import 'package:classes_app/screens/teacher_detail/TeacherDetail.dart';
import 'package:classes_app/screens/student_detail/StudentDetail.dart';
import 'package:classes_app/screens/batches/BatchesList.dart';
import 'package:classes_app/screens/exams/ExamResult.dart';
import 'package:classes_app/screens/announcement/Announcement.dart';
import 'package:classes_app/screens/classroom/ClassRoom.dart';
import 'package:classes_app/screens/teacher/Teacher.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/login": (BuildContext context) => Login(),
  "/parent_login": (BuildContext context) => ParentLogin(),
  "/home": (BuildContext context) => Home(),
  "/attendance": (BuildContext context) => Attendance(),
  "/assignments": (BuildContext context) => Assignments(),
  "/study_material": (BuildContext context) => StudyMaterial(),
  "/Fees": (BuildContext context) => Fees(),
  "/Exams": (BuildContext context) => Exams(),
  "/ExamStart": (BuildContext context) => ExamStart(),
  "/ExamFinished": (BuildContext context) => ExamFinished(),
  "/TeacherDetail": (BuildContext context) => TeacherDetail(),
  "/StudentDetail": (BuildContext context) => StudentDetail(),
  "/BatchesList": (BuildContext context) => BatchesList(),
  "/ExamResult": (BuildContext context) => ExamResult(),
  "/Announcement": (BuildContext context) => Announcement(),
  "/ClassRoom": (BuildContext context) => ClassRoom(),
  "/Teacher": (BuildContext context) => Teacher(),
  "/webviewlink": (BuildContext context) => WebviewLink(),
  "/report": (BuildContext context) => Report(),
};
