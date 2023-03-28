import 'package:flutter/material.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:unai_reminder/repository/repo_authentication.dart';

class Alert extends StatefulWidget {
  const Alert({super.key});

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  bool _isAutoStartEnable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: null,
      body: Center(
          child: SizedBox(
        height: 300,
        width: 380,
        child: Card(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            const Text(
              "Autostart Permission",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Sp',
                  color: Colors.black,
                  fontSize: 45,
                  fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                "This application should run automatically when the device is first turned on. This is necessary to resolve notification issues.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Sp',
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _isAutoStartEnable == true
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                          "Back to my schedule page")) //!need to maintain later
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Back to schedule")),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
              ),
              ElevatedButton(
                  onPressed: () async {
                    UserRepository().write("isFirstLogin", "yeaaa");
                    await getAutoStartPermission();
                    _isAutoStartEnable = true;
                    setState(() {});
                  },
                  child: const Text("Go to settings")),
            ]),
          ],
        )),
      )),
    );
  }
}
