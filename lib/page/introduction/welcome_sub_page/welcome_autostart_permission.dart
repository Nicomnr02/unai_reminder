import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

import '../../../repository/repo_authentication.dart';

class WelcomeAutostartPermission extends StatefulWidget {
  const WelcomeAutostartPermission({super.key});

  @override
  State<WelcomeAutostartPermission> createState() =>
      _WelcomeAutostartPermissionState();
}

class _WelcomeAutostartPermissionState
    extends State<WelcomeAutostartPermission> {
  Future<bool> initAutoStart() async {
    bool status = false;

    try {
      //check auto-start availability.
      var test = await (isAutoStartAvailable);
      //if available then navigate to auto-start setting page.

      if (test!) {
        await getAutoStartPermission();
        status = true;
        return status;
      } else {
        return status;
      }
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return status;
    return status;
  }

  Future<String> getNotiPermissionStatus() async {
    return await UserRepository().read("autostart_status");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Autostart Permission",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Sp",
                  fontWeight: FontWeight.w600,
                  fontSize: 40,
                  fontStyle: FontStyle.italic),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            const SizedBox(
              width: 250,
              child: Text(
                "This application should run automatically in the background. This is necessary to resolve notification issues.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Sp',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 40)),
            FutureBuilder(
                future: getNotiPermissionStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data == "") {
                    return ElevatedButton(
                      onPressed: () async {
                        UserRepository().write("autostart_status", "on");
                        Future.delayed(
                            const Duration(seconds: 2), () => setState(() {}));

                        var availableDirectToAutoStartPage =
                            await initAutoStart();
                        if (availableDirectToAutoStartPage == false) {
                          const AndroidIntent intent = AndroidIntent(
                              action:
                                  'android.settings.APPLICATION_DETAILS_SETTINGS',
                              data: 'package:com.example.unai_reminder');

                          intent.launch();
                        }
                      },
                      child: const Text(
                        "Go to settings",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Sp",
                          fontWeight: FontWeight.w200,
                          fontSize: 20,
                        ),
                      ),
                    );
                  } else {
                    print('autostart mode : ${snapshot.data}');
                    return const Text(
                      "Autostart enabled",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: "Sp",
                        fontWeight: FontWeight.w200,
                        fontSize: 20,
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
