import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unai_reminder/page/authentication/user.dart';
import 'package:unai_reminder/repository/user.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  UserRepository usrData = UserRepository();

  Future<String?> isLogin() async {
    var data = await usrData.read("_cookie");
    if (data != "") {
      return data;
    }
    return data;
  }

  void logout() async {
    usrData.delete();

    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (ctx) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: AppBar(
          title: const Text("Unai Reminder"),
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          const Text(
            "DATA",
            style: TextStyle(fontWeight: FontWeight.w200),
          ),
          ElevatedButton(
            onPressed: logout,
            child: const Text("Logout"),
          )
        ]));
  }
}
