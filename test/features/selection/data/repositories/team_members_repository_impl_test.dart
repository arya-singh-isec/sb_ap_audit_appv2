import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/core/error/exceptions.dart';
import 'package:sb_ap_audit_appv2/core/error/failures.dart';
import 'package:sb_ap_audit_appv2/core/network/network_info.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/datasources/team_members_remote_data_source.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/models/team_member_model.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/repositories/team_members_repository_impl.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/entities/team_member.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockTeamMembersRemoteDataSource extends Mock
    implements TeamMembersRemoteDataSource {}

void main() {
  late MockNetworkInfo mockNetworkInfo;
  late MockTeamMembersRemoteDataSource mockRemoteDataSource;
  late TeamMembersRepositoryImpl repositoryImpl;

  // exception/failure
  final tServerException500 =
      ServerException(code: 500, message: 'Server error!');
  final tServerFailure500 = ServerFailure(code: 500, message: 'Server error!');

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockTeamMembersRemoteDataSource();
    repositoryImpl = TeamMembersRepositoryImpl(
        remoteDataSource: mockRemoteDataSource, networkInfo: mockNetworkInfo);
  });

  group('when the device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    group('getTeamMembers', () {
      const List<TeamMemberModel> tTeamMemberModels = [
        TeamMemberModel(id: '1', name: 'TeamMember A', supervisorId: '23'),
        TeamMemberModel(id: '2', name: 'TeamMember B', supervisorId: '54')
      ];
      const List<TeamMember> tTeamMembers = tTeamMemberModels;

      test(
          'should return a list of team members when the call to remote data source is successful',
          () async {
        // Arrange
        when(mockRemoteDataSource.getTeamMembers())
            .thenAnswer((_) async => tTeamMemberModels);
        // Act
        final result = await repositoryImpl.getTeamMembers();
        // Assert
        verify(mockRemoteDataSource.getTeamMembers());
        expect(result, const Right(tTeamMembers));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // Arrange
        when(mockRemoteDataSource.getTeamMembers())
            .thenThrow(tServerException500);
        // Act
        final result = await repositoryImpl.getTeamMembers();
        // Assert
        expect(result, Left(tServerFailure500));
      });
    });

    group('getSubordinates', () {
      const tSupervisorId = '1';
      const tSubordinateModels = <TeamMemberModel>[
        TeamMemberModel(id: '3', name: 'TeamMemberAA', supervisorId: '1'),
        TeamMemberModel(id: '4', name: 'TeamMemberAB', supervisorId: '1')
      ];
      const List<TeamMember> tSubordinates = tSubordinateModels;

      test(
          'should return a list of subordinates for a team member when the call to remote data source is successful',
          () async {
        // Arrange
        when(mockRemoteDataSource.getSubordinates(tSupervisorId))
            .thenAnswer((_) async => tSubordinateModels);
        // Act
        final result = await repositoryImpl.getSubordinates(tSupervisorId);
        // Assert
        verify(mockRemoteDataSource.getSubordinates(tSupervisorId));
        expect(result, const Right(tSubordinates));
      });

      test(
          'should return a server failure when the call to remote data source is ',
          () async {
        // Arrange
        when(mockRemoteDataSource.getSubordinates(tSupervisorId))
            .thenThrow(tServerException500);
        // Act
        final result = await repositoryImpl.getSubordinates(tSupervisorId);
        // Assert
        expect(result, Left(tServerFailure500));
      });

      test(
          'should return an empty list where there are no subordinates for a given supervisorId',
          () async {
        final tServerException404 =
            ServerException(code: 404, message: 'Resource Not Found!');
        // Arrange
        when(mockRemoteDataSource.getSubordinates(tSupervisorId))
            .thenThrow(tServerException404);
        // Act
        final result = await repositoryImpl.getSubordinates(tSupervisorId);
        // Assert
        expect(result, const Right<Failure, List<TeamMember>?>([]));
      });
    });
  });
}
