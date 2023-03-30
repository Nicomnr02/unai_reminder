import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class AlarmUtils {
  List<List<String>> todaySchedule = [];

  Map<String, int> days = {
    "M.": 1,
    "T.": 2,
    "W.": 3,
    "Th.": 4,
    "F.": 5,
    "S.": 7,
  };

  void sortData() {
    print("before sorted : $todaySchedule");
    for (var i = 0; i < todaySchedule.length; i++) {
      for (var j = 0; j < todaySchedule.length; j++) {
        var currentElHour = int.tryParse(todaySchedule[i][3]) ?? 0;
        var iterableElHour = int.tryParse(todaySchedule[j][3]) ?? 0;
        if (iterableElHour > currentElHour) {
          var temp = todaySchedule[i];
          todaySchedule[i] = todaySchedule[j];
          todaySchedule[j] = temp;
        }
      }
    }
    print('sorted : $todaySchedule');
  }

  void oneShotNotification(int id, String title, String body) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: id,
      channelKey: 'key1',
      title: title,
      body: body,
      displayOnBackground: true,
      displayOnForeground: true,
      fullScreenIntent: true,
      backgroundColor: Colors.black,
      customSound: 'resource://raw/tuturu.mp3',
      notificationLayout: NotificationLayout.BigText,
      bigPicture: 'asset://assets/images/times.png',
    ));
  }

  void alarmBytriggerByOrder(List<List<String>> thistodaySchedule) async {
    sortData();

    // int tempM = DateTime.now().minute + 1;
    // int tempH = DateTime.now().hour;

    for (var i = 0; i < thistodaySchedule.length; i++) {
      var rawHour = thistodaySchedule[i][3];
      var hour = rawHour[0] + rawHour[1];
      int hourInt = int.tryParse(hour) ?? 0;

      if (hourInt == 0) {
        continue;
      }
      // schedule a notification
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: i,
          channelKey: 'key1',
          title: thistodaySchedule[i][1],
          body: thistodaySchedule[i][2],
          displayOnBackground: true,
          displayOnForeground: true,
          fullScreenIntent: true,
          backgroundColor: Colors.black,
          customSound: 'resource://raw/res_custom_notification',
          notificationLayout: NotificationLayout.BigText,
          bigPicture: 'asset://assets/images/times.png',
        ),
        schedule: NotificationCalendar(
            weekday: days[todaySchedule[i][5]],
            hour: hourInt - 1,
            minute: 50,
            second: 0,
            timeZone: "Asia/Jakarta",
            repeats: true,
            allowWhileIdle: true),
      );

      // tempM += 1;
    }
  }

  AlarmUtils(this.todaySchedule) {
    if (todaySchedule.isEmpty == true) {
    } else {
      alarmBytriggerByOrder(todaySchedule);
    }
  }
}
