import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:unai_reminder/page/introduction/page_splash.dart';
import 'package:unai_reminder/utils/utils_alarm.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:unai_reminder/utils/utils_db.dart';
import 'package:timezone/data/latest.dart' as tz;

//!To validate certificate to run some security layer on certain device
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// final fln = FlutterLocalNotificationsPlugin();
final alarmUtil = AlarmUtils([]);
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  DB();
  await AwesomeNotifications().initialize(
    // set the 'default' icon for notifications
    'resource://drawable/app_icon',
    // set the notification channels
    [
      NotificationChannel(
        channelKey: 'key1',
        channelName: 'Channel Name',
        channelDescription: 'Channel Description',
        defaultColor: Colors.red,
        ledColor: Colors.white,
        enableVibration: true,
        vibrationPattern: highVibrationPattern,
        importance: NotificationImportance.High,
        soundSource: 'resource://raw/res_custom_notification',
        playSound: true,
        channelShowBadge: true,
      ),
    ],
  );
  tz.initializeTimeZones();
  GestureBinding.instance.resamplingEnabled = true;
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          home: const SplashPage(),
        ));
  }
}
