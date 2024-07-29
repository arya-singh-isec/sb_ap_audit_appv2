import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/team_member_model.dart';

abstract class TeamMembersRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<List<TeamMemberModel>?>? getTeamMembers();

  /// Throws a [ServerException] for all error codes.
  Future<List<TeamMemberModel>?>? getSubordinates(String? supervisorId);
}

class TeamMembersRemoteDataSourceImpl extends TeamMembersRemoteDataSource {
  final DioClient client;

  TeamMembersRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TeamMemberModel>?>? getTeamMembers() async {
    const String url = 'https://test.example.com/getTeamMembers/all';
    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final List jsonData = response.data['data'];
        final List<TeamMemberModel> models = jsonData
            .map((jsonMap) => TeamMemberModel.fromJson(jsonMap))
            .toList();
        return models;
      } else {
        final error = response.data['error'];
        throw ServerException(code: error['code'], message: error['message']);
      }
    } on Exception {
      throw ServerException(
          code: 500, message: 'Server error. Please try again later!');
    }
  }

  @override
  Future<List<TeamMemberModel>?>? getSubordinates(String? supervisorId) async {
    final String url = 'https://test.example.com/getTeamMembers/$supervisorId';
    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final List jsonData = response.data['data'];
        final List<TeamMemberModel> models = jsonData
            .map((jsonMap) => TeamMemberModel.fromJson(jsonMap))
            .toList();
        return models;
      } else {
        // TODO: Clarify the case when no subordinates are found
        final error = response.data['error'];
        throw ServerException(code: error.code, message: error.message);
      }
    } on Exception {
      throw ServerException(code: 500, message: 'Server error!');
    }
  }
}
