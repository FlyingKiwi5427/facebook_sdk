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
  // String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // String platformVersion;
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   platformVersion = await FacebookSdk.platformVersion;
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }

    // // If the widget was removed from the tree while the asynchronous platform
    // // message was in flight, we want to discard the reply rather than calling
    // // setState to update our non-existent appearance.
    // if (!mounted) return;

    // setState(() {
    //   _platformVersion = platformVersion;
    // });
  }

  void shareLink() async {
    print("share");
    String result = await FacebookSdk.shareLinkContent("https://www.flyingkiwi.nl");
    print(result);
  }

  void fbLogin() async {
    FacebookLoginResult result = await FacebookSdk.logInWithReadPermissions(['email', 'user_gender']);
    print(result.accessToken);
    // final facebookLogin = FacebookLogin();
    // facebookLogin.loginBehavior = FacebookLoginBehavior.nativeOnly;
    // await facebookLogin.logOut();
    // final FacebookLoginResult result = await facebookLogin.logInWithReadPermissions(['email', 'user_gender']);
    // print("Loginresult: " + result.accessToken.toString());
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
