import 'package:shared_preferences/shared_preferences.dart';

class DB {
  Future<SharedPreferences> initDB() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }

 
}
