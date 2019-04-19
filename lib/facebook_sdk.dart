import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

class FacebookSdk {
  static const MethodChannel _channel =
      const MethodChannel('facebook_sdk');

  static Future<String> shareLinkContent(String link) async {
  	final String result = await _channel.invokeMethod('shareLinkContent', { 'link': link });
    return result;
  }

  static Future<FacebookLoginResult> logInWithReadPermissions(List<String> permissions) async {
    final Map<dynamic, dynamic> result = await _channel.invokeMethod('login', { 'permissions': permissions });
    return FacebookLoginResult._(result.cast<String, dynamic>());
  }

  static Future<void> logOut() async => _channel.invokeMethod('logout');
}

class FacebookLoginResult {
  final FacebookLoginStatus status;
  final FacebookAccessToken accessToken;
  final String errorMessage;

  FacebookLoginResult._(Map<String, dynamic> map)
      : status = _parseStatus(map['status']),
        accessToken = map['accessToken'] != null
            ? FacebookAccessToken.fromMap(
                map['accessToken'].cast<String, dynamic>(),
              )
            : null,
        errorMessage = map['errorMessage'];

  static FacebookLoginStatus _parseStatus(String status) {
    switch (status) {
      case 'loggedIn':
        return FacebookLoginStatus.loggedIn;
      case 'cancelledByUser':
        return FacebookLoginStatus.cancelledByUser;
      case 'error':
        return FacebookLoginStatus.error;
    }

    throw StateError('Invalid status: $status');
  }
}

enum FacebookLoginStatus {
  loggedIn,
  cancelledByUser,
  error,
}

class FacebookAccessToken {
  final String token;
  final String userId;
  final DateTime expires;


  final List<String> permissions;
  final List<String> declinedPermissions;

  FacebookAccessToken.fromMap(Map<String, dynamic> map)
      : token = map['token'],
        userId = map['userId'],
        expires = DateTime.fromMillisecondsSinceEpoch(
          map['expires'],
          isUtc: true,
        ),
        permissions = map['permissions'].cast<String>(),
        declinedPermissions = map['declinedPermissions'].cast<String>();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'userId': userId,
      'expires': expires.millisecondsSinceEpoch,
      'permissions': permissions,
      'declinedPermissions': declinedPermissions,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FacebookAccessToken &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          userId == other.userId &&
          expires == other.expires &&
          const IterableEquality().equals(permissions, other.permissions) &&
          const IterableEquality().equals(
            declinedPermissions,
            other.declinedPermissions,
          );

  @override
  int get hashCode =>
      token.hashCode ^
      userId.hashCode ^
      expires.hashCode ^
      permissions.hashCode ^
      declinedPermissions.hashCode;
}
