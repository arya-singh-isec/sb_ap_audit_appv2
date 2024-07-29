import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/login/domain/entities/user.dart';
import '../../features/login/presentation/blocs/bloc.dart';
import '../app.dart';
import '../config/constants.dart';

// UI
void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}

// LOGIC
String generateRandomNumberString() {
  String rv = DateTime.now().millisecondsSinceEpoch.toString();
  return rv.split('').reversed.join().substring(0, 8);
}

String getCurrentTimestamp() {
  DateTime now = DateTime.now();
  String timestamp = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
  return timestamp;
}

String generateChecksum(String data, String timestamp) {
  Uint8List byteData = utf8.encode(timestamp + data + AppConstants.secretKey);
  return sha256.convert(byteData).toString();
}

// API
Object? auditGetData(String requestName) {
  assert(loginBloc.state is LoginSuccess, 'Illegal resource access!');
  final User? user = (loginBloc.state as LoginSuccess).user;
  final currentTimestamp = getCurrentTimestamp();
  final postData = json.encode({
    'UserId': user!.id,
    'SessionToken': user.sessionToken,
    'RequestName': requestName
  });
  final requestBody = {
    'AppKey': AppConstants.appKey,
    'time_stamp': currentTimestamp,
    'JSONPostData': postData,
    'Checksum': generateChecksum(postData.toString(), currentTimestamp)
  };
  return requestBody;
}
