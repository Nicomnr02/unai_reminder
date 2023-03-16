import 'package:unai_reminder/utils/utils_db.dart';

class DashboardRepository {
  final db = DB();

  Future<void> write(String key, List<String> val) async {
    final prefs = await db.initDB();
    await prefs.setStringList(key, val);
    final data = await read(key);
    print("data berisi?? --> ${data[3]}");
  }

  Future<List<String>> read(String key) async {
    final prefs = await db.initDB();
    return prefs.getStringList(key) ?? [];
  }

  void delete() async {
    final prefs = await db.initDB();
    await prefs.remove('_cookie');
    final data = await read("_cookie");
    print("data kosong?? --> $data");
    return;
  }
}
