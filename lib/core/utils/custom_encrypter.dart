import 'dart:convert';

import 'package:encrypt/encrypt.dart';

import '../config/constants.dart';
import 'utils.dart';

class CustomEncrypter {
  static final instance = CustomEncrypter._internal(AppConstants.secretKey, '');

  final String secretKey;
  final IV _iv;

  CustomEncrypter._internal(this.secretKey, String iv) : _iv = IV.fromUtf8(iv);

  factory CustomEncrypter(String key, String iv) {
    return instance;
  }

  String encrypt(String plainText) {
    final rv = generateRandomNumberString();
    final newKey = rv + secretKey.substring(0, 24);
    final encrypter = _createEncrypter(Key.fromUtf8(newKey));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return '${base64.encode(rv.codeUnits)}:${encrypted.base64}';
  }

  String decrypt(String encryptedText) {
    final parts = encryptedText.split(':');
    final newKey =
        utf8.decode(base64.decode(parts[0])) + secretKey.substring(0, 24);
    final encrypter = _createEncrypter(Key.fromUtf8(newKey));
    final decrypted = encrypter.decrypt64(parts[1]);
    return decrypted;
  }

  Encrypter _createEncrypter(Key key) {
    return Encrypter(AES(key, mode: AESMode.ecb));
  }
}
