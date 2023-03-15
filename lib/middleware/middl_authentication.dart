import '../repository/repo_authentication.dart';

class UserMiddleware {
  Future<bool> checkWasLogged() async {
    final userLog = UserRepository();
    final wasLogged = await userLog.read("_cookie");

    if (wasLogged != "") {
      return true;
    }

    return false;
  }
}
