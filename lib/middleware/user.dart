import '../repository/user.dart';

class UserMiddleware {
  Future<bool> checkWasLogged() async {
    final userLog = UserRepository();
    final wasLogged = await userLog.read("_cookie");
    print(wasLogged);

    if (wasLogged != "") {
      return true;
    }

    return false;
  }
}
