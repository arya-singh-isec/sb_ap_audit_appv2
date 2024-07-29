import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/core/error/exceptions.dart';
import 'package:sb_ap_audit_appv2/core/network/dio_client.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/datasources/team_members_remote_data_source.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/models/team_member_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDioClient extends Mock implements DioClient {
  @override
  Future<Response> get(String url, {Map<String, dynamic>? queryParameters}) =>
      super.noSuchMethod(
        Invocation.getter(#get),
        returnValue: Future.value(Response(
            data: {}, requestOptions: RequestOptions(), statusCode: 200)),
        returnValueForMissingStub: Future.value(Response(
            data: {}, requestOptions: RequestOptions(), statusCode: 200)),
      );
}

void main() {
  late MockDioClient mockDioClient;
  late TeamMembersRemoteDataSourceImpl remoteDataSourceImpl;

  setUp(() {
    mockDioClient = MockDioClient();
    remoteDataSourceImpl =
        TeamMembersRemoteDataSourceImpl(client: mockDioClient);
  });

  // const Map<String, String> tHeaders = {'Content-Type': 'application/json'};

  group('getTeamMembers', () {
    const String tUrl = 'https://test.example.com/getTeamMembers/all';
    // const Map<String, String> tHeaders = {'Content-Type': 'application/json'};
    const List<TeamMemberModel> tTeamMemberModels = [
      TeamMemberModel(id: '1', name: 'TeamMember A', supervisorId: '23'),
      TeamMemberModel(id: '2', name: 'TeamMember B', supervisorId: '54')
    ];

    test('should forward GET request to the http client', () async {
      // Arrange
      when(mockDioClient.get(tUrl)).thenAnswer((_) async => Response(
          data: fixture('get_team_members_success.json'),
          requestOptions: RequestOptions(),
          statusCode: 200));
      // Act
      final _ = await remoteDataSourceImpl.getTeamMembers();
      // Assert
      verify(mockDioClient.get(tUrl));
      verifyNoMoreInteractions(mockDioClient);
    });

    test(
        'should return a list of valid models when the response status code is 200 (success)',
        () async {
      // Arrange
      when(mockDioClient.get(tUrl)).thenAnswer((_) async => Response(
          data: fixture('get_team_members_success.json'),
          requestOptions: RequestOptions(),
          statusCode: 200));
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
      when(mockDioClient.get(tUrl)).thenAnswer((_) async => Response(
          data: fixture('get_team_members_failure.json'),
          requestOptions: RequestOptions(),
          statusCode: 500));
      // Act
      final call = remoteDataSourceImpl.getTeamMembers;
      // Assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getSubordinates', () {
    const tSupervisorId = '1';
    const String tUrl =
        'https://test.example.com/getTeamMembers/$tSupervisorId';
    const List<TeamMemberModel> tSubordinateModels = [
      TeamMemberModel(id: '3', name: 'TeamMember AA', supervisorId: '1'),
      TeamMemberModel(id: '4', name: 'TeamMember AB', supervisorId: '1')
    ];

    test(
        'should return a list of valid models when the response statusCode is 200 (success)',
        () async {
      // Arrange
      when(mockDioClient.get(tUrl)).thenAnswer((_) async => Response(
          data: fixture('get_subordinates_success.json'),
          requestOptions: RequestOptions(),
          statusCode: 200));
      // Act
      final result = await remoteDataSourceImpl.getSubordinates(tSupervisorId);
      // Assert
      expect(result, tSubordinateModels);
    });

    // TODO: Clarify whether an exception or empty list will be sent in case no subordinates are found
  });
}
