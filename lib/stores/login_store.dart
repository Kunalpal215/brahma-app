import 'dart:convert';
import 'dart:io';
import 'package:brahma_app/auth/login.dart';
import 'package:http/http.dart' as http;
// import 'package:aad_oauth/aad_oauth.dart';
// import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class LoginStore {
  Map<String, String> userData = <String, String>{};
  final cookieManager = WebviewCookieManager();

  Future<bool> isAlreadyAuthenticated() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    if (user.containsKey("name")) {
      saveToUserData(user);
      return true;
    }
    return false;
  }

  void saveToPreferences(SharedPreferences instance, dynamic data) {
    instance.setString("name", data["displayName"]);
    instance.setString("email", data["mail"]);
    instance.setString("rollno", data["surname"]);
    instance.setString("id", data["id"]);
  }

  void saveToUserData(SharedPreferences instance) {
    userData["name"] = instance.getString("name") ?? " ";
    userData["email"] = instance.getString("email") ?? " ";
    userData["rollno"] = instance.getString("rollno") ?? " ";
    userData["id"] = instance.getString("id") ?? " ";
  }

  void logOut(BuildContext context) async {
    await cookieManager.clearCookies();
    SharedPreferences user = await SharedPreferences.getInstance();
    user.clear();
    userData.clear();
    Navigator.of(context)
        .pushNamed(LoginPage.id);
  }
}
