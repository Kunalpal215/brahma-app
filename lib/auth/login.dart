import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:brahma_app/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  static String id = "/login";

  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: WebView(
            initialUrl: "https://swc.iitg.ac.in/onestopapi/auth/microsoft",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller){
              _controller.complete(controller);
            },
            onPageFinished: (url) async {
              if(url.startsWith("https://swc.iitg.ac.in/onestopapi/auth/microsoft/redirect?code")){
                WebViewController controller = await _controller.future;
                var checkString = await controller.runJavascriptReturningResult("document.querySelector('h1').innerText");
                print(checkString);
                await controller.runJavascriptReturningResult("document.querySelector('#userInfo').innerText").then((value) => print(value)).catchError((err) => print(err));
                var userInfoString = await controller.runJavascriptReturningResult("document.querySelector('#userInfo').innerText");
                print(userInfoString);
                var userInfo = {};
                String check = "";
                int count=1;

                List<String> values = userInfoString.split("/");
                userInfo["displayName"] = values[0];
                userInfo["mail"] = values[1];
                userInfo["surname"] = values[2];
                userInfo["id"]=values[3];
                SharedPreferences user = await SharedPreferences.getInstance();
                context
                    .read<LoginStore>()
                    .saveToPreferences(user, userInfo);
                context
                    .read<LoginStore>()
                    .saveToUserData(user);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              }
            },
          )
      )
    );
  }
}
