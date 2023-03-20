import 'package:flutter/material.dart';
import 'package:unai_reminder/page/dashboard/dashboard_schedule.dart/dashboard_list_content.dart';
import 'package:unai_reminder/repository/repo_authentication.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _username = "";

  Future<String> getUserName() async {
    _username = await UserRepository().read("_username");
    setState(() {});
    return _username;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserName(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                snapshot.data!,
                style: const TextStyle(
                    fontFamily: "Sp",
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              automaticallyImplyLeading: false,
            ),
            body: const ScheduleList(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text("user")),
            body: const ScheduleList(),
          );
        }
      },
    );
  }
}
