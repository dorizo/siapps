import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:classes_app/utils/app_localizations.dart';

class DateFormatter {
  static String getCurrentDate() {
    var outputFormate1 = DateFormat('yyyy-MM-dd');
    return outputFormate1.format(DateTime.now());
  }

  static String getCurrentTime() {
    var outputFormate1 = DateFormat('hh:mm a');
    return outputFormate1.format(DateTime.now());
  }

  static String getConvetedDate(String dateTime, int step) {
    var inputFormate = DateFormat("yyyy-MM-dd");

    var outputFormate1 = DateFormat('MM');
    var outputFormate2 = DateFormat('dd');
    var outputFormate3 = DateFormat('dd-MM-yyyy');
    var outputFormate4 = DateFormat('dd MMMM yyyy');

    if (step == 1) {
      return outputFormate1.format(inputFormate.parse(dateTime));
    } else if (step == 2) {
      return outputFormate2.format(inputFormate.parse(dateTime));
    } else if (step == 3) {
      return outputFormate3.format(inputFormate.parse(dateTime));
    } else if (step == 4) {
      return outputFormate4.format(inputFormate.parse(dateTime));
    } else {
      return dateTime;
    }
  }

  static String getConvetedDateTime(
      BuildContext context, String dateTime, int step) {
    var inputFormate = DateFormat("yyyy-MM-dd HH:mm:ss");

    var outputFormate1 = DateFormat('dd-MM-yyyy hh:mm a');
    var outputFormate2 = DateFormat('dd-MM-yyyy');

    if (step == 1) {
      return outputFormate1
          .format(inputFormate.parse(dateTime))
          .replaceAll("AM", AppLocalizations.of(context).translate("am"))
          .replaceAll("PM", AppLocalizations.of(context).translate("pm"));
    } else if (step == 2) {
      return outputFormate2.format(inputFormate.parse(dateTime));
    } else {
      return dateTime;
    }
  }

  static String getConvetedTime(BuildContext context, String time, int step) {
    var inputFormate = DateFormat("HH:mm:ss");

    var outputFormate1 = DateFormat('hh:mm a');

    if (step == 1) {
      return outputFormate1
          .format(inputFormate.parse(time))
          .replaceAll("AM", AppLocalizations.of(context).translate("am"))
          .replaceAll("PM", AppLocalizations.of(context).translate("pm"));
    } else {
      return time;
    }
  }

  static String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  static bool isDateValid(startDate) {
    var outputFormate = DateFormat("yyyy-MM-dd");
    final dateStart = outputFormate.parse(startDate);
    final dateCurrent = outputFormate.parse(getCurrentDate());

    print("isAtSameMomentAs::${dateCurrent.isAtSameMomentAs(dateStart)}");

    return dateCurrent.isAtSameMomentAs(dateStart);
  }

  static bool isTimeValid(timeStart, int spentMinute) {
    var inputFormate = DateFormat('hh:mm a');
    var outputFormate = DateFormat("HH:mm:ss");

    //final timeStartString = outputFormate.format(inputFormate.parse(timeStart));
    final timeCurrentString =
        outputFormate.format(inputFormate.parse(getCurrentTime()));

    final dateTime = outputFormate.parse(timeStart);
    final dateTimeStart = outputFormate.parse(timeStart);
    final dateTimeEnd = dateTime.add(Duration(minutes: spentMinute));
    final dateTimeCurrent = outputFormate.parse(timeCurrentString);

    print("isAfter::${dateTimeCurrent.isAfter(dateTimeStart)}");
    print("isBefore::${dateTimeCurrent.isBefore(dateTimeEnd)}");
    return dateTimeCurrent.isAfter(dateTimeStart) &&
        dateTimeCurrent.isBefore(dateTimeEnd);
  }

  static bool isTimeValidClasses(timeStart, int spentMinute) {
    var inputFormate = DateFormat('hh:mm a');
    var outputFormate = DateFormat("HH:mm:ss");

    //final timeStartString = outputFormate.format(inputFormate.parse(timeStart));
    final timeCurrentString =
        outputFormate.format(inputFormate.parse(getCurrentTime()));

    final dateTime = outputFormate.parse(timeStart);
    final dateTimeStart = dateTime.add(Duration(minutes: -spentMinute));
    final dateTimeCurrent = outputFormate.parse(timeCurrentString);

    print("isAfter::${dateTimeCurrent.isAfter(dateTimeStart)}");
    return dateTimeCurrent.isAfter(dateTimeStart);
  }
}
