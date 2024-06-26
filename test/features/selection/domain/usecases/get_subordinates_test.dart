import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/entities/team_member.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/repositories/team_members_repository.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/usecases/get_subordinates.dart';

class MockTeamMembersRepository extends Mock implements TeamMembersRepository {}

void main() {
  late GetSubordinates usecase;
  late MockTeamMembersRepository mockTeamMembersRepository;

  setUp(() {
    mockTeamMembersRepository = MockTeamMembersRepository();
    usecase = GetSubordinates(repository: mockTeamMembersRepository);
  });

  const String tSupervisorId = '10';
  const List<TeamMember> tSubordinates = [
    TeamMember(id: '4', name: 'Subordinate_1', supervisorId: tSupervisorId),
    TeamMember(id: '6', name: 'Subordinate_2', supervisorId: tSupervisorId)
  ];

  test('should verify successful subordinate response', () async {
    // Arrange
    when(mockTeamMembersRepository.getSubordinates(tSupervisorId))
        .thenAnswer((_) async => const Right(tSubordinates));
    // Act
    final result = await usecase.execute(tSupervisorId);
    // Assert
    expect(result, const Right(tSubordinates));
    verify(mockTeamMembersRepository.getSubordinates(tSupervisorId));
    verifyNoMoreInteractions(mockTeamMembersRepository);
  });
}
