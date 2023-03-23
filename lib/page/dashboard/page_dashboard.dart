import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unai_reminder/page/dashboard/page_schedule.dart';
import 'package:unai_reminder/repository/repo_authentication.dart';
import 'package:unai_reminder/repository/repo_dashboard.dart';

import '../authentication/page_authentication.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _username = "";
  UserRepository userRepo = UserRepository();
  DashboardRepository dashboardRepo = DashboardRepository();

  var spinkit = const SpinKitThreeBounce(
    color: Colors.blue,
    size: 20.0,
  );

  void logout() async {
    userRepo.delete();

    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (ctx) => const LoginPage()));
  }

  Future<String> getUserName() async {
    _username = await UserRepository().read("_username");
    if (_username == "") {
      setState(() {});
    }
    return _username;
  }

  Future<List<List<String>>> getData() async {
    List<List<String>> scheduleData = List.empty(growable: true);

    var s = await dashboardRepo.read("S.");
    scheduleData.add(s);

    var m = await dashboardRepo.read("M.");
    scheduleData.add(m);

    var t = await dashboardRepo.read("T.");
    scheduleData.add(t);

    var w = await dashboardRepo.read("W.");
    scheduleData.add(w);

    var th = await dashboardRepo.read("Th.");
    scheduleData.add(th);

    var f = await dashboardRepo.read("F.");
    scheduleData.add(f);

    return scheduleData;
  }

  Future<List<List<String>>> retrieveData() async {
    List<List<String>> scheduleData = List.empty(growable: true);
    scheduleData = await getData();

    if (scheduleData == []) {
      setState(() {});
    }

    return scheduleData;
  }

  Future<List<List<String>>> showData() async {
    var scheduleData = await getData();
    List<List<String>> schedules = [];
    int start = 0;
    int end = 0;
    while (true) {
      for (var i = 0; i < scheduleData.length; i++) {
        if (scheduleData[i].isEmpty == true) {
          continue;
        }

        var stringSchedule = scheduleData[i];
        var splitted = stringSchedule[0].split("|");
        var isMoreThanOneMajor = splitted.contains("conjunction");

        if (isMoreThanOneMajor == true) {
          for (var j = 0; j < splitted.length; j++) {
            if (j == splitted.length - 1) {
              schedules.add(splitted.sublist(start + 1));
              start = 0;
              end = 0;
              break;
            }

            if (splitted[j] == "conjunction") {
              end = j;
              if (start == 0) {
                var clearSchedule = splitted.sublist(start, end);
                schedules.add(clearSchedule);
                start = end;
                end = 0;
              } else {
                var clearSchedule = splitted.sublist(start + 1, end);
                schedules.add(clearSchedule);
                start = end;
                end = 0;
                continue;
              }
            }
          }
        } else {
          schedules.add(splitted);
        }
      }
      print(schedules);
      return schedules;
    }
  }

  String getTimeForProperGreeting(){
    var time = DateTime.now();
    return "";
    //Todo : finish this!
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([getUserName(), showData()]),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            final username = snapshot.data[0] as String;
            final schedule = snapshot.data[1] as List<List<String>>;
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        username == ""
                            ? spinkit
                            : Text(
                                "Good {obj} $username",
                                style: const TextStyle(
                                    fontFamily: "Sp",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                        ElevatedButton.icon(
                            onPressed: logout,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent)),
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            label: const Text("")),
                      ],
                    ),
                  ),
                ]),
                backgroundColor: Colors.black,
                elevation: 0,
                automaticallyImplyLeading: false,
              ),
              body: SchedulePage(schedule),
            );
          } else {
            return const Text("failed");
          }
        });
  }
}
