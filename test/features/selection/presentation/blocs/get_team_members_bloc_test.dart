import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/core/error/failures.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/entities/team_member.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/usecases/get_subordinates.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/usecases/get_team_members.dart';
import 'package:sb_ap_audit_appv2/features/selection/presentation/blocs/get_team_members_bloc.dart';
import 'package:sb_ap_audit_appv2/features/selection/presentation/blocs/get_team_members_event.dart';
import 'package:sb_ap_audit_appv2/features/selection/presentation/blocs/get_team_members_state.dart';

class MockGetTeamMembers extends Mock implements GetTeamMembers {}

class MockGetSubordinates extends Mock implements GetSubordinates {}

void main() {
  late GetTeamMembersBloc bloc;
  late MockGetTeamMembers mockGetTeamMembers;
  late MockGetSubordinates mockGetSubordinates;

  setUp(() {
    mockGetTeamMembers = MockGetTeamMembers();
    mockGetSubordinates = MockGetSubordinates();
    bloc = GetTeamMembersBloc(
        getTeamMembers: mockGetTeamMembers,
        getSubordinates: mockGetSubordinates);
  });

  test('initialState should be TeamMembersEmpty', () async {
    // Assert
    expect(bloc.state, equals(TeamMembersEmpty()));
  });

  const List<TeamMember> tTeamMembers = [
    TeamMember(id: '1', name: 'TeamMember A', supervisorId: '23'),
    TeamMember(id: '2', name: 'TeamMember B', supervisorId: '54')
  ];

  group('getTeamMembers', () {
    test(
        'should emit events [TeamMembersLoading, TeamMembersHierarchyLoaded] when fetch team members list is successful',
        () async {
      // Arrange
      when(mockGetTeamMembers.execute())
          .thenAnswer((_) async => const Right(tTeamMembers));
      // Assert Later
      final expected = [
        TeamMembersLoading(),
        TeamMembersHierarchyLoaded(
            topLevelMembers: tTeamMembers, subordinates: const {})
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // Act
      bloc.add(FetchTeamMembersList());
      await untilCalled(mockGetTeamMembers.execute());
    });

    test(
        'should emit [TeamMembersLoading, TeamMembersError] when fetch team members is unsuccessful',
        () async {
      // Arrange
      when(mockGetTeamMembers.execute()).thenAnswer((_) async =>
          Left(ServerFailure(code: 500, message: 'Server error!')));
      // Assert Later
      final expected = [
        TeamMembersLoading(),
        TeamMembersError(message: 'Server error!')
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // Act
      bloc.add(FetchTeamMembersList());
      await untilCalled(mockGetTeamMembers.execute());
    });
  });

  group('getSubordinates', () {
    const tSupervisorId = '1';
    const List<TeamMember> tSubordinates = [
      TeamMember(id: '3', name: 'TeamMember AA', supervisorId: '1'),
      TeamMember(id: '4', name: 'TeamMember AB', supervisorId: '1')
    ];

    test(
        'should emit [TeamMembersLoading, TeamMembersHierarchyLoaded] when fetch subordinates list is successful',
        () async {
      // Arrange
      when(mockGetSubordinates.execute(tSupervisorId))
          .thenAnswer((_) async => const Right(tSubordinates));
      // Set initial state
      final initialState = TeamMembersHierarchyLoaded(
          topLevelMembers: tTeamMembers, subordinates: const {});
      bloc.emit(initialState);

      // Assert Later
      final expected = [
        TeamMembersLoading(),
        TeamMembersHierarchyLoaded(
            topLevelMembers: tTeamMembers,
            subordinates: const {tSupervisorId: tSubordinates})
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // Act
      bloc.add(FetchSubordinatesList(supervisorId: tSupervisorId));
      await untilCalled(mockGetSubordinates.execute(tSupervisorId));
    });
  });
}
