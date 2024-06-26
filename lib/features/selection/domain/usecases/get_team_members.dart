import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/team_member.dart';
import '../repositories/team_members_repository.dart';

class GetTeamMembers {
  final TeamMembersRepository repository;

  GetTeamMembers({required this.repository});

  Future<Either<Failure, List<TeamMember>>?>? execute() async {
    return await repository.getTeamMembers();
  }
}
