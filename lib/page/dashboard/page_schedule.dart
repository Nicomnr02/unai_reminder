import 'dart:math';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SchedulePage extends StatefulWidget {
  List<List<String>> schedule = [];
  SchedulePage(this.schedule, {super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
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

    amountDays[0] = "TODAY";

    return amountDays;
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
                    onTap: () {},
                    child: index == 0
                        ? Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  '${getAmountDayInCurrentMonth()[0].toString()} ',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Sp",
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
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
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.schedule.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 350,
                child: Card(
                  color: schedulebackground[
                      Random().nextInt(schedulebackground.length - 1)],
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: ListTile(
                    title: Center(
                      child: Column(
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 80)),
                          Center(
                            child: Text(
                              widget.schedule[index][1],
                              style: const TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 3,
                                  fontFamily: 'Sp',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 30),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 30)),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  '${widget.schedule[index][0]} | ${widget.schedule[index][2]}',
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
            },
          ),
        )
      ],
    );
  }
}
