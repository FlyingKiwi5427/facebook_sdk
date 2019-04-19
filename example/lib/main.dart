import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:facebook_sdk/facebook_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  void shareLink() async {
    String result = await FacebookSdk.shareLinkContent("https://www.flyingkiwi.nl");
  }

  void fbLogin() async {
    await FacebookSdk.logOut();
    FacebookLoginResult result = await FacebookSdk.logInWithReadPermissions(['email', 'user_gender']);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            FlatButton(
              child: Text("Login"),
              onPressed: () {
                fbLogin();
              },
            ),
            FlatButton(
              child: Text("Share"),
              onPressed: () {
                shareLink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
