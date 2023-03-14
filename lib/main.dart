import 'dart:io';
import 'package:flutter/material.dart';
import 'package:unai_reminder/page/dashboard/dashboard.dart';
import 'package:unai_reminder/page/screen_router/screen.dart';
import 'package:unai_reminder/page/splash.dart';
import 'package:unai_reminder/utils/db.dart';

void main() async {
  DB();
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
    return const MaterialApp(
      //still checking caous its cons
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
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
