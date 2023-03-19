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

  Future<List<String>> getData() async {
    var scheduleData = await dashboardRepo.read("_scheduleObj");
    setState(() {});
    return scheduleData;
  }

  void logout() async {
    userRepo.delete();

    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (ctx) => const LoginPage()));
  }

  Widget bottomNavBarContentBuilder(List<String> scheduleData) {
    final List<Widget> widgetOptions = <Widget>[
      scheduleData.isEmpty
          ? responseMessage.errorPageBuilder(context, "failed") //! will be check
          : ListView.separated(
              itemBuilder: (context, index) => const Divider(),
              separatorBuilder: (context, index) {
                return Text(scheduleData[index]);
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
        future: getData(),
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
                        icon: Icon(Icons.alarm), label: 'Schedule'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: 'My Profile'),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ));
          } else if (snapshot.hasError) {
            return const Text("error retrieving data");
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
