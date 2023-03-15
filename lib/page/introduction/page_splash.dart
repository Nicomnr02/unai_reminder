import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unai_reminder/page/router/router_page_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var spinkit = const SpinKitPouringHourGlass(
    color: Colors.yellow,
    size: 50.0,
  );

  void navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 1));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Screen("")));
  }

  @override
  void initState() {
    super.initState();
    navigateToMainScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.amberAccent,
          body: Center(
            child: Image.asset('assets/images/times.png'),
          ),
        ));
  }
}
