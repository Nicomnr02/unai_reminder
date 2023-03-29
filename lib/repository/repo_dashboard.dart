import 'package:unai_reminder/utils/utils_db.dart';

class DashboardRepository {
  final db = DB();
  List<String>? scheduleData;

  Future<void> write(String key, List<String> val) async {
    final prefs = await db.initDB();
    await prefs.setStringList(key, val);
    // final data = await read(key);
    // print("data berisi?? --> ${data[3]}");
  }

  Future<List<String>> read(String key) async {
    final prefs = await db.initDB();
    scheduleData = prefs.getStringList(key) ?? [];
    return scheduleData!;
  }
}
