import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sb_ap_audit_appv2/core/error/exceptions.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/datasources/team_members_remote_data_source.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/models/team_member_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {
  @override
  Future<http.Response> get(Uri uri, {Map<String, String>? headers}) =>
      super.noSuchMethod(
        Invocation.getter(#get),
        returnValue: Future.value(http.Response('{}', 200)),
        returnValueForMissingStub: Future.value(http.Response('{}', 200)),
      );
}

void main() {
  late MockHttpClient mockHttpClient;
  late TeamMembersRemoteDataSourceImpl remoteDataSourceImpl;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSourceImpl =
        TeamMembersRemoteDataSourceImpl(client: mockHttpClient);
  });

  const Map<String, String> tHeaders = {'Content-Type': 'application/json'};

  group('getTeamMembers', () {
    final Uri tUrl = Uri.parse('https://test.example.com/getTeamMembers/all');
    const Map<String, String> tHeaders = {'Content-Type': 'application/json'};
    const List<TeamMemberModel> tTeamMemberModels = [
      TeamMemberModel(id: '1', name: 'TeamMember A', supervisorId: '23'),
      TeamMemberModel(id: '2', name: 'TeamMember B', supervisorId: '54')
    ];

    test('should forward GET request to the http client', () async {
      // Arrange
      when(mockHttpClient.get(tUrl, headers: tHeaders)).thenAnswer((_) async =>
          http.Response(fixture('get_team_members_success.json'), 200));
      // Act
      final _ = await remoteDataSourceImpl.getTeamMembers();
      // Assert
      verify(mockHttpClient.get(tUrl, headers: tHeaders));
      verifyNoMoreInteractions(mockHttpClient);
    });

    test(
        'should return a list of valid models when the response status code is 200 (success)',
        () async {
      // Arrange
      when(mockHttpClient.get(tUrl, headers: tHeaders)).thenAnswer((_) async =>
          http.Response(fixture('get_team_members_success.json'), 200));
      // Act
      final result = await remoteDataSourceImpl.getTeamMembers();
      // Assert
      expect(result, isA<List<TeamMemberModel>?>());
      expect(result?.length, tTeamMemberModels.length);
      for (int i = 0; i < result!.length; i++) {
        expect(result[i], tTeamMemberModels[i]);
      }
    });

    test(
        'should return a server exception when the response statusCode is not 200',
        () async {
      // Arrange
      when(mockHttpClient.get(tUrl, headers: tHeaders)).thenAnswer((_) async =>
          http.Response(fixture('get_team_members_failure.json'), 500));
      // Act
      final call = remoteDataSourceImpl.getTeamMembers;
      // Assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getSubordinates', () {
    const tSupervisorId = '1';
    final Uri tUrl =
        Uri.parse('https://test.example.com/getTeamMembers/$tSupervisorId');
    const List<TeamMemberModel> tSubordinateModels = [
      TeamMemberModel(id: '3', name: 'TeamMember AA', supervisorId: '1'),
      TeamMemberModel(id: '4', name: 'TeamMember AB', supervisorId: '1')
    ];

    test(
        'should return a list of valid models when the response statusCode is 200 (success)',
        () async {
      // Arrange
      when(mockHttpClient.get(tUrl, headers: tHeaders)).thenAnswer((_) async =>
          http.Response(fixture('get_subordinates_success.json'), 200));
      // Act
      final result = await remoteDataSourceImpl.getSubordinates(tSupervisorId);
      // Assert
      expect(result, tSubordinateModels);
    });

    // TODO: Clarify whether an exception or empty list will be sent in case no subordinates are found
  });
}
