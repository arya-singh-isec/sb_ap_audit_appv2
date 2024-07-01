import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/team_member_model.dart';

abstract class TeamMembersRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<List<TeamMemberModel>?>? getTeamMembers();

  /// Throws a [ServerException] for all error codes.
  Future<List<TeamMemberModel>?>? getSubordinates(String? supervisorId);
}

class TeamMembersRemoteDataSourceImpl extends TeamMembersRemoteDataSource {
  final http.Client client;

  TeamMembersRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TeamMemberModel>?>? getTeamMembers() async {
    final Uri url = Uri.parse('https://test.example.com/getTeamMembers/all');
    try {
      final response =
          await client.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body)['data'];
        final List<TeamMemberModel> models = jsonData
            .map((jsonMap) => TeamMemberModel.fromJson(jsonMap))
            .toList();
        return models;
      } else {
        final error = json.decode(response.body)['error'];
        throw ServerException(code: error['code'], message: error['message']);
      }
    } on Exception {
      throw ServerException(
          code: 500, message: 'Server error. Please try again later!');
    }
  }

  @override
  Future<List<TeamMemberModel>?>? getSubordinates(String? supervisorId) async {
    final Uri url =
        Uri.parse('https://test.example.com/getTeamMembers/$supervisorId');
    try {
      final response =
          await client.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body)['data'];
        final List<TeamMemberModel> models = jsonData
            .map((jsonMap) => TeamMemberModel.fromJson(jsonMap))
            .toList();
        return models;
      } else {
        // TODO: Clarify the case when no subordinates are found
        final error = json.decode(response.body)['error'];
        throw ServerException(code: error.code, message: error.message);
      }
    } on Exception {
      throw ServerException(code: 500, message: 'Server error!');
    }
  }
}
