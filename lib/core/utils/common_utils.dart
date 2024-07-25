import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

// Logic
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
