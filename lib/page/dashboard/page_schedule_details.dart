import 'package:flutter/material.dart';
import 'package:unai_reminder/model/model_schedule.dart';

// ignore: must_be_immutable
class ScheduleDetailsPage extends StatelessWidget {
  var scheduleModel = ScheduleModel();
  Color squareColor;
  ScheduleDetailsPage(this.scheduleModel, this.squareColor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: null,
      body: Column(children: [
        Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 10),
                  child: Icon(
                    Icons.square,
                    color: squareColor,
                    size: 40,
                  ),
                ),
                Expanded(
                    child: Text(
                  scheduleModel.majorName,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontFamily: 'Sp',
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )),
              ],
            )),
        Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Icon(
                  Icons.key,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Text(
                scheduleModel.majorKey,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontFamily: 'Sp',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Icon(
                  Icons.alarm,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Text(
                'Every ${scheduleModel.day} at ${scheduleModel.time}',
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontFamily: 'Sp',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Expanded(
                child: Text(
                  scheduleModel.lectureName,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                      fontFamily: 'Sp',
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100, left: 20),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close_rounded,
                color: Colors.black,
                size: 30,
              )),
        ),
      ]),
    );
  }
}
