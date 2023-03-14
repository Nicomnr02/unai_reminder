import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unai_reminder/page/screen_router/screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var spinkit = const SpinKitWanderingCubes(
    color: Colors.yellow,
    size: 50.0,
  );

  void navigateToMainScreen() async {
    //handle no internet connection below (with push to another page )

    await Future.delayed(const Duration(seconds: 3));
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
            backgroundColor: Colors.lightBlueAccent,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Text(
                        "My Unai Schedule",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w200),
                      )),
                  Container(child: spinkit),
                ],
              ),
            )));
  }
}
