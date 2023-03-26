import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:unai_reminder/main.dart';

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
        }

        onReceiveNotification(context, detail.payload!);
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
  }

  void onReceiveNotification(BuildContext context, String payload) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  }

  void alarmBytriggerByOrder(List<List<String>> todaySchedule) async {
    var nowHour = DateTime.now().hour;

    for (var i = 0; i < todaySchedule.length; i++) {
      int scheduleStart = int.tryParse(todaySchedule[i][3]) ?? 0;
      int scheduleDuration = int.tryParse(todaySchedule[i][4]) ?? 0;
      int scheduleEnd = (scheduleStart + scheduleDuration) * 60;
      int triggerCountDown = (scheduleStart - nowHour) * 60;

      if (todaySchedule[i][3] == '10') {
        setNotifScheduled("88", "88", todaySchedule[i][1], todaySchedule[i][2],
            "trigger", 10);
        await Future.delayed(const Duration(seconds: 10));
      } else {
        setNotifScheduled("88", "88", todaySchedule[i][1], todaySchedule[i][2],
            "trigger", 10);
        await Future.delayed(const Duration(seconds: 10));
      }
    }
  }

  AlarmUtils(this.todaySchedule) {
    sortData();

    if (todaySchedule.isEmpty != true) {
      alarmBytriggerByOrder(todaySchedule);
    }
  }
}

@pragma('vm:entry-point')
void onReceiveNotification(
    BuildContext ctx, NotificationResponse response) async {
  WidgetsFlutterBinding.ensureInitialized();
  Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => const MyApp(),
      ));
}
