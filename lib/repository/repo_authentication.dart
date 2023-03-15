import 'package:unai_reminder/utils/utils_db.dart';

class UserRepository {
  final db = DB();

  void write(String cookie) async {
    final prefs = await db.initDB();
    await prefs.setString('_cookie', cookie);
    final data = await read("_cookie");
    print("data berisi?? --> $data");
    return;
  }

  Future<String> read(String key) async {
    final prefs = await db.initDB();
    String stringValue = prefs.getString(key) ?? '';
    return stringValue;
  }

  void delete() async {
    final prefs = await db.initDB();
    await prefs.remove('_cookie');
    final data = await read("_cookie");
    print("data kosong?? --> $data");
    return;
  }
}
