import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/common_utils.dart';
import '../../domain/entities/credentials.dart';
import '../models/user_model.dart';

// Designed in a way similar to the repository
abstract class UserRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<UserModel?>? login(Credentials? credentials);

  /// Throws a [ServerException] for all error codes.
  Future<bool?>? logout();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel?>? login(Credentials? credentials) async {
    final Uri url = Uri.parse(ApiConstants.login);
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    try {
      final encryptedPass = credentials!.password.split(':');
      final postData = json.encode({
        'Domain': 'ICICISECURITIES',
        'UserCode': utf8.decode(base64.decode(encryptedPass[0])),
        'UserId': credentials.username,
        'UserPassword': encryptedPass[1]
      });
      final currentTimestamp = getCurrentTimestamp();
      final requestBody = {
        'AppKey': AppConstants.appKey,
        'time_stamp': currentTimestamp,
        'JSONPostData': postData,
        'Checksum': generateChecksum(postData.toString(), currentTimestamp)
      };

      final response = await client.post(url,
          headers: headers, body: json.encode(requestBody));
      final responseBody = json.decode(response.body);
      if (responseBody['Status'] == 200) {
        responseBody['Success']['Id'] = credentials.username;
        return UserModel.fromJson(responseBody);
      } else {
        throw ServerException(
            code: responseBody['Status'], message: responseBody['Error']);
      }
    } on Exception catch (e) {
      if (e is ServerException) {
        throw ServerException(code: e.code, message: e.message);
      } else {
        throw ServerException(
            code: 500, message: 'Server error. Please try again later!');
      }
    }
  }

  @override
  Future<bool?>? logout() async {
    final Uri url = Uri.parse('https://test.example.com/logout');
    try {
      final response =
          await client.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return Future.value(json.decode(response.body)['success']);
      } else {
        final body = json.decode(response.body);
        throw ServerException(code: body['Status'], message: body['Error']);
      }
    } on Exception {
      throw ServerException(
          code: 500, message: 'Server error. Please try again later.');
    }
  }
}
