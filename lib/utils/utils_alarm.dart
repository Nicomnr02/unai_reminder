import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:unai_reminder/main.dart';
import 'package:unai_reminder/model/model_alarm.dart';
import 'package:unai_reminder/page/dashboard/page_alarm.dart';

class AlarmUtils {
  List<List<String>> todaySchedule = [];

  void sortData() {
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

  Future<dynamic> onSelectNotification(payload) async {
    if (payload != "") {
      var triggerSchedule = AlarmModel().newAlarmModel(payload!);
      navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (context) => AlarmPage(triggerSchedule)),
      );
    }
  }

  Future<void> initAlarm(BuildContext context,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    WidgetsFlutterBinding.ensureInitialized();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (detail) async {
        if (detail.payload == '') {
          return;
        } else {
          onSelectNotification(detail.payload);
        }
      },
    );
  }

  Future<void> setNotifOneShot(
    String chanID,
    String chanName,
    String title,
    String description,
  ) async {
    String channelId = chanID;
    String channelName = chanName;
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      enableLights: true,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    fln.show(0, title, description, notificationDetails, payload: '');
  }

  Future<void> setNotifScheduled(
    String chanID,
    String chanName,
    String title,
    String description,
    String payload,
    int nextMinute,
  ) async {
    var now = tz.TZDateTime.now(tz.local);
    String channelId = chanID;
    String channelName = chanName;
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      enableLights: true,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    var scheduledDate = now.add(Duration(seconds: nextMinute)); //! next minute

    const int notificationId = 1;
    await fln.zonedSchedule(
      notificationId,
      title,
      description,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );

    fln.show(1, title, description, notificationDetails, payload: payload);
  }

  void alarmBytriggerByOrder(List<List<String>> thistodaySchedule) async {
    sortData();
    var nowHour = DateTime.now().hour;
    var nowMinute = DateTime.now().minute;

    for (var i = 0; i < thistodaySchedule.length; i++) {
      //int.tryParse(thistodaySchedule[i][3]) ?? 0
      int scheduleStart = 15;
      int scheduleDuration = int.tryParse(thistodaySchedule[i][4]) ?? 0;
      int triggerCountDown = (scheduleStart * 60) -
          ((nowHour * 60) + (nowMinute + 10)); // 10 minutes before
      var endHour = scheduleStart + scheduleDuration;

      print('triggerCT: $triggerCountDown');

      if (triggerCountDown <= 0) {
        //! will fix later
        continue;
      } else {
        await Future.delayed(
          Duration(minutes: triggerCountDown),
          () {
            print(" delay $i done");
            setNotifScheduled(
                "88",
                "88",
                thistodaySchedule[i][1],
                thistodaySchedule[i][2],
                "${thistodaySchedule[i][1]} | $scheduleStart.00 - $endHour.00",
                0);
          },
        );
      }
    }

    fln.cancelAll();
    todaySchedule = [];
  }

  AlarmUtils(this.todaySchedule) {
    if (todaySchedule.isEmpty == true) {
      print("no data in today schedule");
    } else {
      alarmBytriggerByOrder(todaySchedule);
    }
  }
}
