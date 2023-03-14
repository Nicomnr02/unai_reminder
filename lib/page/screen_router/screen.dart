import 'package:flutter/material.dart';
import 'package:unai_reminder/model/response.dart';
import 'package:unai_reminder/page/authentication/user.dart';
import 'package:unai_reminder/page/dashboard/dashboard.dart';
import 'package:unai_reminder/page/screen_router/response.dart';
import 'package:unai_reminder/repository/user.dart';

// ignore: must_be_immutable
class Screen extends StatelessWidget {
  String messageResp;
  bool isFirstLogin = true;
  Screen(this.messageResp, {super.key});

  UserRepository usrData = UserRepository();
  ResponseMessage responseMsg = ResponseMessage();

  Future<String?> isLogin() async {
    var data = await usrData.read("_cookie");
    if (data != "") {
      return data;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: null,
        body: Center(
          child: FutureBuilder(
            future: isLogin(),
            builder: (context, snapshot) {
              if (messageResp == "No Internet") {
                responseMsg.erorrResp(context, messageResp);
                return const LoginPage(); //handling error
              } else if (snapshot.data != "") {
                return const DashboardPage();
              } else if (snapshot.error != null) {
                responseMsg.erorrResp(context, snapshot.error.toString());
                return const LoginPage(); //handling error
              } else if (snapshot.data == "" && messageResp == "") {
                //to handle notif to disappear when firstlogin
                return const LoginPage();
              } else {
                responseMsg.erorrResp(context, messageResp);
                return const LoginPage();
              }
            },
          ),
        ));
  }
}
