import 'dart:io';
import 'dart:math';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:unai_reminder/main.dart';
import 'package:unai_reminder/model/model_schedule.dart';
import 'package:unai_reminder/page/dashboard/page_schedule_details.dart';
import 'package:unai_reminder/utils/utils_alarm.dart';

import '../../repository/repo_authentication.dart';
import '../router/router_alert.dart';

// ignore: must_be_immutable
class SchedulePage extends StatefulWidget {
  List<List<String>> schedule = [];
  String username = "";
  SchedulePage(this.schedule, this.username, {super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<List<String>> choosenSchedule = [];
  List<List<String>> todaySchedule = [];
  int _selectedIdx = -1;
  bool _isFirstOpen = true;
  bool _isNoScheduleToday = false;
  bool _isNotifShowOneTime = false;
  UserRepository userRepo = UserRepository();

  Future<void> initAutoStart() async {
    var isFirstLogin = await userRepo.read("isFirstLogin");
    if (isFirstLogin.isNotEmpty == true) {
      return;
    }

    try {
      //check auto-start availability.
      var test = await (isAutoStartAvailable);
      print(test);
      //if available then navigate to auto-start setting page.

      if (test!) {
        navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => const Alert()),
        );
      }
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
  }

  var spinkit = const SpinKitThreeInOut(
    color: Colors.blue,
    size: 20.0,
  );
  var schedulebackground = [
    Colors.lightGreen,
    Colors.lightBlue,
    Colors.yellow,
    const Color.fromARGB(255, 202, 166, 209),
  ];

  List<String> getAmountDayInCurrentMonth() {
    var time = DateTime.now();
    var month = time.month;
    var year = time.year;

    var nextMonth = DateTime(year, month + 1, 1);
    var lastDayOfMonth = nextMonth.subtract(const Duration(days: 1));

    List<String> amountDays = [];
    for (var i = time.day; i <= lastDayOfMonth.day; i++) {
      amountDays.add(i.toString());
    }

    return amountDays;
  }

  void getChoosenSchedule(String date) {
    var time = DateTime.now();
    var month = time.month;
    var year = time.year;

    var day = "";
    if (month < 10) {
      final dateName = DateFormat("dd-MM-y").parse('$date-0$month-$year');
      day = dateName.weekday.toString();
    } else {
      final dateName = DateFormat("dd-MM-y").parse('$date-$month-$year');
      day = dateName.weekday.toString();
    }

    var scheduleList = widget.schedule;
    if (day == "1") {
      if (choosenSchedule.isEmpty == false) {
        choosenSchedule = [];
      }
      for (var i = 0; i < scheduleList.length; i++) {
        if (scheduleList[i][5] == "M.") {
          choosenSchedule.add(scheduleList[i]);
          continue;
        } else {
          continue;
        }
      }
    }
    if (day == "2") {
      if (choosenSchedule.isEmpty == false) {
        choosenSchedule = [];
      }
      for (var i = 0; i < scheduleList.length; i++) {
        if (scheduleList[i][5] == "T.") {
          choosenSchedule.add(scheduleList[i]);
          continue;
        } else {
          continue;
        }
      }
    }
    if (day == "3") {
      if (choosenSchedule.isEmpty == false) {
        choosenSchedule = [];
      }
      for (var i = 0; i < scheduleList.length; i++) {
        if (scheduleList[i][5] == "W.") {
          choosenSchedule.add(scheduleList[i]);
          continue;
        } else {
          continue;
        }
      }
    }
    if (day == "4") {
      if (choosenSchedule.isEmpty == false) {
        choosenSchedule = [];
      }
      for (var i = 0; i < scheduleList.length; i++) {
        if (scheduleList[i][5] == "Th.") {
          choosenSchedule.add(scheduleList[i]);
          continue;
        } else {
          continue;
        }
      }
    }
    if (day == "5") {
      if (choosenSchedule.isEmpty == false) {
        choosenSchedule = [];
      }
      for (var i = 0; i < scheduleList.length; i++) {
        if (scheduleList[i][5] == "F.") {
          choosenSchedule.add(scheduleList[i]);
          continue;
        } else {
          continue;
        }
      }
    }
    if (day == "7") {
      if (choosenSchedule.isEmpty == false) {
        choosenSchedule = [];
      }
      for (var i = 0; i < scheduleList.length; i++) {
        if (scheduleList[i][5] == "S.") {
          choosenSchedule.add(scheduleList[i]);
          continue;
        } else {
          continue;
        }
      }
    }
  }

  List<List<String>> getTodaySchedule() {
    var time = DateTime.now();
    var month = time.month;
    var year = time.year;
    var date = time.day.toString();

    var day = "";
    if (month < 10) {
      final dateName = DateFormat("dd-MM-y").parse('$date-0$month-$year');
      day = dateName.weekday.toString();
    } else {
      final dateName = DateFormat("dd-MM-y").parse('$date-$month-$year');
      day = dateName.weekday.toString();
    }

    var scheduleList = widget.schedule;
    if (day == "1") {
      if (todaySchedule.isEmpty == false) {
        todaySchedule = [];
      }
      for (var i = 0; i < scheduleList.length; i++) {
        if (scheduleList[i][5] == "M.") {
          todaySchedule.add(scheduleList[i]);
          continue;
        } else {
          continue;
        }
      }
    }
    if (day == "2") {
      if (todaySchedule.isEmpty == false) {
        todaySchedule = [];
      }
      for (var i = 0; i < scheduleList.length; i++) {
        if (scheduleList[i][5] == "T.") {
          todaySchedule.add(scheduleList[i]);

          continue;
        } else {
          continue;
        }
      }
    }
    if (day == "3") {
      if (todaySchedule.isEmpty == false) {
        todaySchedule = [];
      }
      for (var i = 0; i < scheduleList.length; i++) {
        if (scheduleList[i][5] == "W.") {
          todaySchedule.add(scheduleList[i]);

          continue;
        } else {
          continue;
        }
      }
    }
    if (day == "4") {
      if (todaySchedule.isEmpty == false) {
        todaySchedule = [];
      }
      for (var i = 0; i < scheduleList.length; i++) {
        if (scheduleList[i][5] == "Th.") {
          todaySchedule.add(scheduleList[i]);

          continue;
        } else {
          continue;
        }
      }
    }
    if (day == "5") {
      if (todaySchedule.isEmpty == false) {
        todaySchedule = [];
      }
      for (var i = 0; i < scheduleList.length; i++) {
        if (scheduleList[i][5] == "F.") {
          todaySchedule.add(scheduleList[i]);

          continue;
        } else {
          continue;
        }
      }
    }
    if (day == "7") {
      if (todaySchedule.isEmpty == false) {
        todaySchedule = [];
      }
      for (var i = 0; i < scheduleList.length; i++) {
        if (scheduleList[i][5] == "S.") {
          todaySchedule.add(scheduleList[i]);

          continue;
        } else {
          continue;
        }
      }
    }

    setState(() {});

    print('firstopenSchedule: $todaySchedule');
    return todaySchedule;
  }

  void sortData() {
    for (var i = 0; i < choosenSchedule.length; i++) {
      for (var j = 0; j < choosenSchedule.length; j++) {
        var currentElHour = int.tryParse(choosenSchedule[i][3]) ?? 0;
        var iterableElHour = int.tryParse(choosenSchedule[j][3]) ?? 0;
        if (iterableElHour > currentElHour) {
          var temp = choosenSchedule[i];
          choosenSchedule[i] = choosenSchedule[j];
          choosenSchedule[j] = temp;
        }
      }
    }
    print('sortedCHOOSEN : $todaySchedule');
  }

  List<String?> getDayAndMonthName() {
    const Map<int, String> weekdayName = {
      1: "Monday",
      2: "Tuesday",
      3: "Wednesday",
      4: "Thursday",
      5: "Friday",
      6: "Saturday",
      7: "Sunday"
    };

    var day = weekdayName[DateTime.now().weekday];
    var dayInt = DateTime.now().day;

    return [day, dayInt.toString()];
  }

  List<List<String>> sendTodayScheduleToAlarm(List<List<String>> scheduleData) {
    sleep(const Duration(seconds: 10));
    if (scheduleData.isEmpty == true) {
      print("no data sended to alarm page");
      return [
        ["No schedule, have a nice day!"]
      ];
    }
    print("success sended data to alarm page : $scheduleData");
    return scheduleData;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: getAmountDayInCurrentMonth().length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  InkWell(
                    onTap: () {
                      initAutoStart();

                      _isNoScheduleToday;
                      if (_isNoScheduleToday == true) {
                        choosenSchedule = [];
                      }
                      getChoosenSchedule(getAmountDayInCurrentMonth()[index]);

                      _isFirstOpen = false;
                      if (_selectedIdx == index) {
                        _selectedIdx = -1;
                      } else {
                        _selectedIdx = index;
                      }

                      _isNotifShowOneTime;
                      if (getTodaySchedule().isEmpty == true &&
                          _isNotifShowOneTime == false) {
                        _isNotifShowOneTime = true;
                        Future.delayed(
                          const Duration(seconds: 2),
                          () {
                            alarmUtil.setNotifOneShot(
                                "0",
                                "No schedule",
                                "Hi ${widget.username}!",
                                "Looks like you don't have any schedule today, but please be stay productive yaa?");
                          },
                        );
                      }
                      choosenSchedule;

                      setState(() {});
                    },
                    child: index == 0
                        ? Row(
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 14),
                                  child: Column(
                                    children: [
                                      Text(
                                        "${getDayAndMonthName()[0]} ${getDayAndMonthName()[1]}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Sp",
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        'TODAY ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Sp",
                                            fontSize: 40,
                                            fontWeight: index == _selectedIdx
                                                ? FontWeight.w600
                                                : _isFirstOpen == true
                                                    ? FontWeight.w600
                                                    : FontWeight.w300),
                                      ),
                                    ],
                                  )),
                              const Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.access_time_filled,
                                    color: Colors.lightBlue,
                                  ))
                            ],
                          )
                        : Text(
                            '${getAmountDayInCurrentMonth()[index].toString()}  ',
                            style: TextStyle(
                                color: index == _selectedIdx
                                    ? Colors.red
                                    : Colors.white,
                                fontFamily: "Sp",
                                fontSize: 40)),
                  )
                ],
              );
            },
          ),
        ),
        Expanded(
            flex: 7,
            child: getTodaySchedule().isNotEmpty == true && _isFirstOpen == true
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: todaySchedule.length,
                    itemBuilder: (context, index) {
                      AlarmUtils(todaySchedule);
                      print('today schedule after build: $todaySchedule');
                      return SizedBox(
                          height: 250,
                          child: InkWell(
                            onTap: () {
                              int scheduleStart =
                                  int.tryParse(todaySchedule[index][3]) ?? 0;
                              int scheduleDuration =
                                  int.tryParse(todaySchedule[index][4]) ?? 0;
                              var endHour = scheduleStart + scheduleDuration;
                              var newScheduleFormat = ScheduleModel();
                              newScheduleFormat.majorName =
                                  todaySchedule[index][1];
                              newScheduleFormat.lectureName =
                                  todaySchedule[index][2];
                              newScheduleFormat.majorKey =
                                  todaySchedule[index][0];
                              newScheduleFormat.day = todaySchedule[index][5];
                              newScheduleFormat.time =
                                  "$scheduleStart.00 - $endHour.00";
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ScheduleDetailsPage(newScheduleFormat),
                                  ));
                            },
                            child: Card(
                              color: schedulebackground[Random()
                                  .nextInt(schedulebackground.length - 1)],
                              borderOnForeground: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: ListTile(
                                title: Center(
                                  child: Column(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 80)),
                                      Center(
                                        child: Text(
                                          todaySchedule[index][1],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              letterSpacing: 3,
                                              fontFamily: 'Sp',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30),
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 30)),
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              '${todaySchedule[index][0]} | ${todaySchedule[index][2]} | ${todaySchedule[index][3]} ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ));
                    })
                : choosenSchedule.isEmpty == true
                    ? const Center(
                        child: Text(
                          "No schedule, have a nice day <3",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: choosenSchedule.length,
                        itemBuilder: (context, index) {
                          _isNoScheduleToday = true;
                          sortData();
                          return SizedBox(
                              height: 250,
                              child: InkWell(
                                onTap: () {
                                  int scheduleStart =
                                      int.tryParse(choosenSchedule[index][3]) ??
                                          0;
                                  int scheduleDuration =
                                      int.tryParse(choosenSchedule[index][4]) ??
                                          0;
                                  var endHour =
                                      scheduleStart + scheduleDuration;
                                  var newScheduleFormat = ScheduleModel();
                                  newScheduleFormat.majorName =
                                      choosenSchedule[index][1];
                                  newScheduleFormat.lectureName =
                                      choosenSchedule[index][2];
                                  newScheduleFormat.majorKey =
                                      choosenSchedule[index][0];
                                  newScheduleFormat.day =
                                      choosenSchedule[index][5];
                                  newScheduleFormat.time =
                                      "$scheduleStart.00 - $endHour.00";
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ScheduleDetailsPage(
                                                newScheduleFormat),
                                      ));
                                },
                                child: Card(
                                  color: schedulebackground[Random()
                                      .nextInt(schedulebackground.length - 1)],
                                  borderOnForeground: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: ListTile(
                                    title: Center(
                                      child: Column(
                                        children: [
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 80)),
                                          Center(
                                            child: Text(
                                              choosenSchedule[index][1],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  letterSpacing: 3,
                                                  fontFamily: 'Sp',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 30),
                                            ),
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 30)),
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  '${choosenSchedule[index][0]} | ${choosenSchedule[index][2]} | ${choosenSchedule[index][4]} SKS ',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        })),
      ],
    );
  }
}
