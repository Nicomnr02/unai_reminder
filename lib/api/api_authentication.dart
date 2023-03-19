import 'dart:async';
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' as html_parser;

import 'package:unai_reminder/middleware/middl_authentication.dart';
import 'package:unai_reminder/model/model_creds.dart';
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

  // void parser(String htmlData) async {
  //   var cookie = await userRepo.read("_cookie");
  //   if (cookie != "") {
  //     return;
  //   }

  //   List<String> htmlTr = [];
  //   dom.Document document = html_parser.parse(htmlData);
  //   List<dom.Element> rows = document.getElementsByTagName('tr');
  //   if (rows.isEmpty) {
  //     print('empty');
  //   }

  //   for (dom.Element row in rows) {
  //     String value = row.text;
  //     htmlTr.add(value);
  //   }

  //   await dashRepo.write("_schedule", htmlTr);
  // }

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
      print(doc);

      var nameRows = doc.getElementsByClassName("username");
      if (nameRows.isEmpty) {
        return;
      }
      for (var name in nameRows) {
        print(name.text);
      }

      var rows = doc.getElementsByTagName('tr');
      if (rows.isEmpty) {
        return;
      }
      var data = <String>[];
      for (var row in rows) {
        data.add(row.text);
      }

      await dashRepo.write("_scheduleObj", data);
    } catch (e) {
      return;
    }

    // print("null? ${data[1]}");
  }

  Future login(BuildContext context, String username, String password) async {
    var authStatus = await getCredentialFromServer(username, password, context);
    var cookie = authStatus.cookie;
    userRepo.write(cookie!);

    getDataFromServer(cookie);

    // ignore: use_build_context_synchronously
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Screen(responseString)));
  }

  UserAPI(BuildContext context, String username, String password) {
    login(context, username, password);
  }
}
