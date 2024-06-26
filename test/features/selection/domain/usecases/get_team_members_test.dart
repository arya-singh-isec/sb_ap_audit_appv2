import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/entities/team_member.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/repositories/team_members_repository.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/usecases/get_team_members.dart';

class MockTeamMembersRepository extends Mock implements TeamMembersRepository {}

void main() {
  late GetTeamMembers usecase;
  late MockTeamMembersRepository mockTeamMembersRepository;

  setUp(() {
    mockTeamMembersRepository = MockTeamMembersRepository();
    usecase = GetTeamMembers(repository: mockTeamMembersRepository);
  });

  const List<TeamMember> tTeamMembers = [
    TeamMember(id: '1', name: 'Partner A', supervisorId: ''),
    TeamMember(id: '2', name: 'Partner B', supervisorId: '')
  ];

  test('should verify successful team members response', () async {
    // Arrange
    when(mockTeamMembersRepository.getTeamMembers())
        .thenAnswer((_) async => const Right(tTeamMembers));
    // Act
    final result = await usecase.execute();
    // Assert
    expect(result, const Right(tTeamMembers));
    verify(mockTeamMembersRepository.getTeamMembers());
    verifyNoMoreInteractions(mockTeamMembersRepository);
  });
}
