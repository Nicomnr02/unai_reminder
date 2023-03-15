import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:unai_reminder/middleware/middl_authentication.dart';
import 'package:unai_reminder/model/model_creds.dart';
import 'package:unai_reminder/page/router/router_page_router.dart';

import '../repository/repo_authentication.dart';

//! API resource
final dashboardURL = Uri.parse("https://online.unai.edu/mhs/welcome.php");
final loginURL = Uri.parse("https://online.unai.edu/mhs/login.php");

class UserAPI {
  UserMiddleware userMiddl = UserMiddleware();
  UserRepository userRepo = UserRepository();
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

  Future<dynamic> getDataFromServer(String cookie) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result != true) {
      responseString = 'Please check your internet connection!';
      return Credential("", "", "");
    }

    final client = http.Client();
    final request = http.Request('GET', dashboardURL);
    request.headers['cookie'] = cookie;
    final dashboardResponse = await client.send(request);
    if (dashboardResponse.statusCode != 200) {
      return Future.value(false);
    }
    client.close;
    print(await dashboardResponse.stream.bytesToString());
  }

  Future login(BuildContext context, String username, String password) async {
    var authStatus = await getCredentialFromServer(username, password, context);
    var cookie = authStatus.cookie;

    print(getDataFromServer(cookie!));

    userRepo.write(cookie);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Screen(responseString)));
  }

  UserAPI(BuildContext context, String username, String password) {
    login(context, username, password);
  }
}
