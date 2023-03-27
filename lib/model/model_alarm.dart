class AlarmModel {
  String title = "";
  String time = "";
  String leftMinutes = "10 minutes before";
  String events = "UNIVERSITAS ADVENT INDONESIA - ";

   AlarmModel newAlarmModel(String raw) {
    var data = raw.split("|");
    var newAlarmModel = AlarmModel();
    newAlarmModel.title = data[0];
    newAlarmModel.time = data[1];
    return newAlarmModel;
  }
}
