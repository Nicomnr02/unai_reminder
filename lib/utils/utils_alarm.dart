import 'dart:io';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../repository/repo_dashboard.dart';

Future<void> startTask() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register the task with the system.

  final service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: false,
        autoStartOnBoot: true,
        autoStart: true,
      ));

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  print('Task started...');
  DartPluginRegistrant.ensureInitialized();

//! disini logicnya scheduler
//! ----------------------------
  await isolateNextSchedule();
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  final deviceInfo = DeviceInfoPlugin();
  String? device;
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    device = androidInfo.model;
  }

  service.invoke(
    'update',
    {
      "current_date": DateTime.now().toIso8601String(),
      "device": device,
    },
  );
}

Map<int, String> days = {1: "M.", 2: "T.", 3: "W.", 4: "Th.", 5: "F.", 7: "S."};
List<List<String>> scheduleGlobe = [];
Future<void> isolateNextSchedule() async {
  var id = DateTime.now().weekday + 1;

  await AndroidAlarmManager.periodic(
      rescheduleOnReboot: true,
      exact: true,
      allowWhileIdle: true,
      wakeup: true,
      startAt: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 7), //every 7 am
      const Duration(hours: 24),
      id,
      runAppAuto);
}

@pragma('vm:entry-point')
void runAppAuto() async {
  var nextDay = DateTime.now().weekday + 1;
  var nextDayAbbr = days[nextDay];
  List<List<String>> nextSchedules = [];

  var rawNextDaySchedule = await DashboardRepository().read(nextDayAbbr!);
  var splitted = rawNextDaySchedule[0].split("|");
  var isMoreThanOneMajor = splitted.contains("conjunction");
  int start = 0;
  int end = 0;

  if (isMoreThanOneMajor == true) {
    for (var j = 0; j < splitted.length; j++) {
      if (j == splitted.length - 1) {
        nextSchedules.add(splitted.sublist(start + 1));
        start = 0;
        end = 0;
        break;
      }

      if (splitted[j] == "conjunction") {
        end = j;
        if (start == 0) {
          var clearSchedule = splitted.sublist(start, end);
          nextSchedules.add(clearSchedule);
          start = end;
          end = 0;
        } else {
          var clearSchedule = splitted.sublist(start + 1, end);
          nextSchedules.add(clearSchedule);
          start = end;
          end = 0;
          continue;
        }
      }
    }
  } else {
    nextSchedules.add(splitted);
  }

  if (nextSchedules.isEmpty == true) {
    AlarmUtils([
      ["empty"]
    ]);
  } else {
    AlarmUtils(nextSchedules);
  }

  print("nextScheduleTrigger : $nextSchedules");
}

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
    if (todaySchedule[0][0] == "empty") {
      oneShotNotification(9090, "No schedule tomorrow", "Have a nice day!");
      await startTask();
      return;
    } else {
      await startTask();
    }
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
