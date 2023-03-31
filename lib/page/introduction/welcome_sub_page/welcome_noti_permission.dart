import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:unai_reminder/page/authentication/page_authentication.dart';
import 'package:unai_reminder/repository/repo_authentication.dart';
import 'package:unai_reminder/utils/utils_alarm.dart';

class WelcomeNotificationPermission extends StatefulWidget {
  const WelcomeNotificationPermission({super.key});

  @override
  State<WelcomeNotificationPermission> createState() =>
      _WelcomeNotificationPermissionState();
}

class _WelcomeNotificationPermissionState
    extends State<WelcomeNotificationPermission> {
  void getNotiPermission() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
        print("Notif Enable");
        return;
      }
      print("Notif Enable");
      return;
    });
  }

  Future<String> getNotiPermissionStatus() async {
    return await UserRepository().read("permission_status");
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
              "Notification Permission",
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
              width: 200,
              child: Text(
                "This app needs access to send notifications about your upcoming study schedule.",
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
                      getNotiPermission();
                      AlarmUtils([]).oneShotNotification(67,
                          "Permission has been granted", "You can login now!");
                      UserRepository().write("permission_status", "success");
                      setState(() {});
                    },
                    child: const Text(
                      "Give access now",
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
                  print('snapshot data : ${snapshot.data}');
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ));
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      "Login now",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Sp",
                        fontWeight: FontWeight.w200,
                        fontSize: 20,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
