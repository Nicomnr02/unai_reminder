import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unai_reminder/page/router/router_response.dart';

import '../../../repository/repo_authentication.dart';
import '../../../repository/repo_dashboard.dart';
import '../../authentication/page_authentication.dart';

class ScheduleList extends StatefulWidget {
  const ScheduleList({super.key});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  UserRepository userRepo = UserRepository();
  DashboardRepository dashboardRepo = DashboardRepository();
  ResponseMessage responseMessage = ResponseMessage();

  int _selectedIndex = 0;

  Future<List<List<String>>> getData() async {
    // List<String> days = ["S.", "M.", "T.", "W.", "Th.", "F."];
    List<List<String>> scheduleData = List.empty(growable: true);
    // scheduleData = [
    //   await dashboardRepo.read("S."),
    //   await dashboardRepo.read("M."),
    //   await dashboardRepo.read("T."),
    //   await dashboardRepo.read("W."),
    //   await dashboardRepo.read("Th."),
    //   await dashboardRepo.read("F."),
    // ];

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

    //![LATER] make looping from 'scheduleData' above to get hours/time for alarm needed.
  }

  Future<List<List<String>>> showData() async {
    var scheduleData = await getData();

    setState(() {});
    return scheduleData;
  }

  void logout() async {
    userRepo.delete();

    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (ctx) => const LoginPage()));
  }

  Widget bottomNavBarContentBuilder(List<List<String>> scheduleData) {
    final List<Widget> widgetOptions = <Widget>[
      scheduleData.isEmpty
          ? const CircularProgressIndicator()
          : //! alarm here
          const Scaffold(
              appBar: null,
            ),
      ListView.separated(
          itemBuilder: (context, index) => const Divider(),
          separatorBuilder: (context, index) {
            return Text('${scheduleData[index]}'); //! will be card!
          },
          itemCount: scheduleData.length),
      ElevatedButton(onPressed: logout, child: const Text("logout")),
    ];

    return Center(child: widgetOptions.elementAt(_selectedIndex));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: showData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: null,
                body: Center(
                  child: snapshot.data != null
                      ? bottomNavBarContentBuilder(snapshot.data!)
                      : const CircularProgressIndicator(),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  iconSize: 35,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.alarm), label: 'Alarm'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.schedule_outlined), label: 'Schedule'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: 'My Profile'),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ));
          } else if (snapshot.hasError) {
            return responseMessage.errorPageBuilder(
                context, "Server Error, try again!");
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
