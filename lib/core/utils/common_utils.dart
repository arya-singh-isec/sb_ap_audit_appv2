import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sb_ap_audit_appv2/core/widgets/custom_toast.dart';

import '../../features/login/domain/entities/user.dart';
import '../../features/login/presentation/blocs/bloc.dart';
import '../app.dart';
import '../config/constants.dart';

// UI
void showToastMessage(BuildContext context, String message) {
  CustomToast.show(context, message);
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
