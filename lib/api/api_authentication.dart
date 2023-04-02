import 'dart:async';
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' as html_parser;

import 'package:unai_reminder/model/model_creds.dart';
import 'package:unai_reminder/page/router/router_page_router.dart';
import 'package:unai_reminder/repository/repo_dashboard.dart';

import '../repository/repo_authentication.dart';

//! API resource
final dashboardURL = Uri.parse("https://online.unai.edu/mhs/mk_disetujui.php");
final loginURL = Uri.parse("https://online.unai.edu/mhs/login.php");

class UserAPI {
  UserRepository userRepo = UserRepository();
  DashboardRepository dashRepo = DashboardRepository();

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
      }).timeout(const Duration(seconds: 5));

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

  Future<List<String>> saveDataToSharedPf(List<String> splitted) async {
    var pointerTodata =
        splitted.indexWhere((element) => element.contains("Phone:"));

    var day = splitted[pointerTodata + 4];

    var majorKey = splitted[1];
    var majorName = (splitted
        .sublist(
            2, splitted.indexWhere((element) => element.contains("Prodi:")))
        .join(" "));

    var pointerToLectureName =
        splitted.indexWhere((element) => element.contains("Prodi:"));
    var lectureName = (splitted
        .sublist(pointerToLectureName + 1, pointerTodata - 1)
        .join(" "));

    var temp = splitted[pointerTodata + 5];
    var time = temp[0] + temp[1];

    var sksAmount = splitted[pointerTodata + 2];

    var existSchedule = await dashRepo.read(day);
    if (existSchedule.isEmpty == false) {
      var currentSchedule = existSchedule[0];
      existSchedule = [];
      var conjuctionVar = "conjunction";
      existSchedule.add(
          '$currentSchedule|$conjuctionVar|$majorKey|$majorName|$lectureName|$time|$sksAmount|$day');
      dashRepo.write(day, existSchedule);
      return existSchedule;
    }

    dashRepo.write(
        day, ['$majorKey|$majorName|$lectureName|$time|$sksAmount|$day']);

    return await dashRepo.read(day);
  }

  void getDataFromServer(String cookie) async {
    try {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result != true) {
        responseString = 'Please check your internet connection!';
        return;
      }

      if (cookie.contains(",") == true) {
        var temp = cookie.split(',');
        cookie = temp[1];
      }

      http.Response resp = await http.get(dashboardURL, headers: {
        'Cookie': cookie,
      });


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
        var splittedName = name.text.split(" ");
        userRepo.write("_username", splittedName[0]);
      }

      var rowsData = doc.getElementsByTagName('td');
      var rows = doc.getElementsByTagName('tr');
      if (rows.isEmpty) {
        return;
      }
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
        await saveDataToSharedPf(splitted);
      }
    } catch (e) {
      return;
    }
  }

  Future login(BuildContext context, String username, String password) async {
    var authStatus = await getCredentialFromServer(username, password, context);
    var cookie = authStatus.cookie;
    userRepo.write("_cookie", cookie!);

    getDataFromServer(cookie);

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Screen(responseString)));
  }

  UserAPI(BuildContext context, String username, String password) {
    login(context, username, password);
  }
}
