import 'dart:async';
import 'dart:ffi';
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' as html_parser;

import 'package:unai_reminder/middleware/middl_authentication.dart';
import 'package:unai_reminder/model/model_creds.dart';
import 'package:unai_reminder/model/model_dashboard.dart';
import 'package:unai_reminder/page/router/router_page_router.dart';
import 'package:unai_reminder/repository/repo_dashboard.dart';

import '../repository/repo_authentication.dart';

//! API resource
final dashboardURL = Uri.parse("https://online.unai.edu/mhs/mk_disetujui.php");
final loginURL = Uri.parse("https://online.unai.edu/mhs/login.php");

class UserAPI {
  UserMiddleware userMiddl = UserMiddleware();
  UserRepository userRepo = UserRepository();
  DashboardRepository dashRepo = DashboardRepository();

  DashboardModel dashModel = DashboardModel();

  String responseString = "";

  Future<Credential> getCredentialFromServer(
      String username, String password, BuildContext context) async {
    String? cookie;

    bool result = await InternetConnectionChecker().hasConnection;
    if (result != true) {
      responseString = 'Please check your internet connection!';
      return Credential("", "", "");
    }

    if (username == "" && password == "") {
      responseString = 'Empty username and password!';
      return Credential("", "", "");
    }

    var client = http.Client();
    try {
      final response = await client.post(loginURL, headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'username': username,
        'password': password
      }).timeout(const Duration(seconds: 7));

      if (response.statusCode != 302) {
        responseString = "Username or Password is wrong";
        return Credential("", "", "");
      }
      cookie = response.headers['set-cookie']!; // save cookie
    } on TimeoutException catch (_) {
      responseString =
          "Connection Timeout! \n Unai server may to be down or you weren't connect to internet";
      return Credential("", "", "");
    } catch (_) {
      return Credential("", "", "");
    }

    responseString = "Login Success";
    return (Credential(username, password, cookie));
  }

  void getDataFromServer(String cookie) async {
    try {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result != true) {
        responseString = 'Please check your internet connection!';
        return;
      }
      http.Response resp =
          await http.get(dashboardURL, headers: {'Cookie': cookie});

      if (resp.statusCode != 200) {
        responseString = 'Try again!';
        return;
      }
      dom.Document doc = html_parser.parse(resp.body);

      var nameRows = doc.getElementsByClassName("username");
      if (nameRows.isEmpty) {
        return;
      }
      for (var name in nameRows) {
        userRepo.write("_username", name.text);
      }

      var rowsData = doc.getElementsByTagName('td');
      var rows = doc.getElementsByTagName('tr');
      if (rows.isEmpty) {
        return;
      }
      // List<String> listData = List.generate(6, (index) => "");
      // for (var j = 7; j < days.length; j++) {
      //   if (rows[j].text.contains("S")) {
      //     data[0] += "${rows[j].text} |";
      //   } else if (days[j].text.contains("M")) {
      //     data[1] += "${rows[j].text} |";
      //   } else if (days[j].text.contains("T")) {
      //     data[2] += "${rows[j].text} |";
      //   } else if (days[j].text.contains("W")) {
      //     data[3] += "${rows[j].text} |";
      //   } else if (days[j].text.contains("Th")) {
      //     data[4] += "${rows[j].text} |";
      //   } else if (days[j].text.contains("F")) {
      //     data[5] += "${rows[j].text} |";
      //   }

      List<String> data = [];
      int counter = 0;
      String rowData = "";
      for (var i = 0; i < rowsData.length; i++) {
        if (counter != 8) {
          rowData += "${rowsData[i].text} ";
          counter += 1;
          continue;
        }
        data.add(rowData);
        rowData = "";
        counter = 0;
      }

      for (var j = 0; j < data.length; j++) {
        var splitted = data[j].split(" ");
        if (splitted.contains("S.")) {
          print('Sunday Class: ${splitted[2]} \n');
        } else if (splitted.contains("M.")) {
          print('Monday Class: ${splitted[2]}\n');
        } else if (splitted.contains("T.")) {
          print('Tuesday Class: ${splitted[2]}\n');
        } else if (splitted.contains("W.")) {
          print('Wednesday Class:${splitted[2]}\n');
        } else if (splitted.contains("Th.")) {
          var majorKey = splitted[1];
          var majorName = splitted.sublist(
              2, splitted.indexWhere((element) => element.contains("Prodi:")));

          var lastIdxForLectureName =
              splitted.indexWhere((element) => element.contains("Phone:"));
          var lectureName = splitted.sublist(
              lastIdxForLectureName - 5, lastIdxForLectureName);

          print('Thursday Class:$majorKey - $majorName - $lectureName\n');
        } else if (splitted.contains("F.")) {
          print('Friday Class: ${splitted[2]}\n');
        }
      }
      await dashRepo.write("_scheduleObj", []);
    } catch (e) {
      return;
    }

    // print("null? ${data[1]}");
  }

  Future login(BuildContext context, String username, String password) async {
    var authStatus = await getCredentialFromServer(username, password, context);
    var cookie = authStatus.cookie;
    userRepo.write("_cookie", cookie!);

    getDataFromServer(cookie);

    // ignore: use_build_context_synchronously
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Screen(responseString)));
  }

  UserAPI(BuildContext context, String username, String password) {
    login(context, username, password);
  }
}
