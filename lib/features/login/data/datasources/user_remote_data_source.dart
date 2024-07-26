import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/config/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/common_utils.dart';
import '../../domain/entities/credentials.dart';
import '../models/user_model.dart';
import '../../../../core/network/dio_client.dart';

abstract class UserRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<UserModel?>? login(Credentials? credentials);

  /// Throws a [ServerException] for all error codes.
  Future<bool?>? logout();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dioClient;

  UserRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel?>? login(Credentials? credentials) async {
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

      final response = await dioClient.post(ApiConstants.login, data: requestBody);
      final responseBody = response.data;
      if (responseBody['Status'] == 200) {
        responseBody['Success']['Id'] = credentials.username;
        return UserModel.fromJson(responseBody);
      } else {
        throw ServerException(
            code: responseBody['Status'], message: responseBody['Error']);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
            code: e.response!.statusCode!,
            message: e.response!.data['Error']);
      } else {
        throw ServerException(
            code: 500, message: 'Server error. Please try again later!');
      }
    }
  }

  @override
  Future<bool?>? logout() async {
    try {
      final response = await dioClient.get('https://test.example.com/logout');
      if (response.statusCode == 200) {
        return Future.value(response.data['success']);
      } else {
        final body = response.data;
        throw ServerException(code: body['Status'], message: body['Error']);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
            code: e.response!.statusCode!,
            message: e.response!.data['Error']);
      } else {
        throw ServerException(
            code: 500, message: 'Server error. Please try again later!');
      }
    }
  }
}
