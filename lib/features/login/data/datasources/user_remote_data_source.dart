import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
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
    final Uri url = Uri.parse('https://test.example.com/login');
    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      final body = json.decode(response.body);
      throw ServerException(
          code: body['error']['code'], message: body['error']['message']);
    }
  }

  @override
  Future<bool?>? logout() async {
    final Uri url = Uri.parse('https://test.example.com/logout');
    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return Future.value(json.decode(response.body)['success']);
    } else {
      final body = json.decode(response.body);
      throw ServerException(
          code: body['error']['code'], message: body['error']['message']);
    }
  }
}
