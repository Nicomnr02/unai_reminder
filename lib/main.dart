import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:unai_reminder/page/introduction/page_splash.dart';
import 'package:unai_reminder/utils/utils_alarm.dart';

import 'package:unai_reminder/utils/utils_db.dart';
import 'package:timezone/data/latest.dart' as tz;


final fln = FlutterLocalNotificationsPlugin();
final alarmUtil = AlarmUtils([]);
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  DB();
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
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
  void initState() {
    super.initState();
    alarmUtil.initAlarm(context, fln);
  }


  

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
          //still checking caous its cons
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          home: const SplashPage(),
        ));
  }
}

//!To validate certificate to run some security layer on certain device
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
