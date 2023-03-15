
class Credential {
  String username = "";
  String password = "";
  String? cookie = "";
  Credential(this.username, this.password, this.cookie);
}

class Schedule {
  var scheduleDays = {}; //this should be map type
  var scheduleHours = {}; // this should be map type

  Map<String, dynamic> temp = {};
}
