import 'package:flutter/material.dart';
import 'package:unai_reminder/page/dashboard/page_dashboard.dart';
import 'package:unai_reminder/page/introduction/page_welcome.dart';
import 'package:unai_reminder/page/router/router_response.dart';
import 'package:unai_reminder/repository/repo_authentication.dart';

// ignore: must_be_immutable
class Screen extends StatelessWidget {
  String responseString;
  Screen(this.responseString, {super.key});

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
      body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: FutureBuilder(
              future: isLogin(),
              builder: (context, snapshot) {
                var rspNoInternet = "Lost internet!";
                if (responseString ==
                    'Please check your internet connection!') {
                  return responseMsg.errorPageBuilder(context, rspNoInternet);
                } else if (snapshot.error != null) {
                  return responseMsg.errorPageBuilder(
                      context, snapshot.error.toString());
                } else if (snapshot.data == "" && responseString == "") {
                  return const IntroductionPage();
                } else if (snapshot.data == "") {
                  return responseMsg.errorPageBuilder(context, responseString);
                } else {
                  print('kuki bapak kau = ${snapshot.data}');
                  return const DashboardPage();
                }
              },
            ),
          )),
    );
  }
}
