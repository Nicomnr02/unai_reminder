import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DB {
  Future<SharedPreferences> initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }

 
}
