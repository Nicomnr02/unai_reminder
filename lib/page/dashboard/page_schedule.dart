import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SchedulePage extends StatefulWidget {
  List<List<String>> schedule = [];
  SchedulePage(this.schedule, {super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<List<String>> choosenSchedule = [];
  List<List<String>> todaySchedule = [];
  bool _isFirstOpen = true;

  var spinkit = const SpinKitPianoWave(
    color: Colors.blue,
    size: 20.0,
  );
  var schedulebackground = [
    Colors.lightGreen,
    Colors.lightBlue,
    Colors.yellow,
    const Color.fromARGB(255, 192, 126, 204),
    Colors.amberAccent,
    Colors.deepOrange,
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
          var y = choosenSchedule;
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
          var y = choosenSchedule;
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
          var y = choosenSchedule;
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
          var y = choosenSchedule;
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
          var y = choosenSchedule;
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
          var y = choosenSchedule;
          continue;
        } else {
          continue;
        }
      }
    }

    print('choosen: $choosenSchedule');
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
                      getChoosenSchedule(getAmountDayInCurrentMonth()[index]);
                      setState(() {
                        _isFirstOpen = false;
                      });
                    },
                    child: index == 0
                        ? Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'TODAY ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Sp",
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.access_time_filled,
                                    color: Colors.lightBlue,
                                  ))
                            ],
                          )
                        : Text(
                            '${getAmountDayInCurrentMonth()[index].toString()}  ',
                            style: const TextStyle(
                                color: Colors.white,
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
                    if (todaySchedule.isEmpty == true) {
                      return const Center(
                        child: Text("No schedule today, have a nice day <3"),
                      );
                    } else {
                      return SizedBox(
                        height: 350,
                        child: Card(
                          color: schedulebackground[
                              Random().nextInt(schedulebackground.length - 1)],
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
                                          '${todaySchedule[index][0]} | ${todaySchedule[index][2]}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w200),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  })
              : todaySchedule.isEmpty == true
                  ? spinkit
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: choosenSchedule.length,
                      itemBuilder: (context, index) {
                        if (todaySchedule.isEmpty == true) {
                          return const Center(
                            child:
                                Text("No schedule today, have a nice day <3"),
                          );
                        } else {
                          return SizedBox(
                            height: 350,
                            child: Card(
                              color: schedulebackground[Random()
                                  .nextInt(schedulebackground.length - 1)],
                              borderOnForeground: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Center(
                                  child: Column(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 80)),
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
                                          padding: EdgeInsets.only(top: 30)),
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              '${choosenSchedule[index][0]} | ${choosenSchedule[index][2]}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
        )
      ],
    );
  }
}
