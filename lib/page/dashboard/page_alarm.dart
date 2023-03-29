import 'package:flutter/material.dart';
import 'package:unai_reminder/model/model_alarm.dart';

// ignore: must_be_immutable
class AlarmPage extends StatelessWidget {
  AlarmModel triggerSchedule;
  AlarmPage(this.triggerSchedule, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
              height: 700,
              width: 360,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 20),
                    child: Text(
                      triggerSchedule.title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontFamily: 'Sp',
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_filled,
                          color: Colors.white,
                        ),
                        Text(
                          '  Today at ${triggerSchedule.time}',
                          style: const TextStyle(
                            fontFamily: 'Sp',
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 150, top: 110),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // fln.cancel(1);
                            },
                            child: const Icon(Icons.close))
                      ],
                    ),
                  )
                ],
              ) // Add your card content here
              ),
        ));
  }
}
