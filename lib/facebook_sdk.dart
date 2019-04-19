import 'dart:async';

import 'package:flutter/services.dart';

class FacebookSdk {
  static const MethodChannel _channel =
      const MethodChannel('facebook_sdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> shareLinkContent(String link) async {
  	//final String version = 
  	final String result = await _channel.invokeMethod('shareLinkContent', { 'link': link });
    return result;
  }
}
