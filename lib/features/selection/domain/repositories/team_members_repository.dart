import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/team_member.dart';

abstract class TeamMembersRepository {
  // Added Null subtype for unit testss
  Future<Either<Failure, List<TeamMember>>?>? getTeamMembers();
  // Added Null subtype for unit tests
  Future<Either<Failure, List<TeamMember>>?>? getSubordinates(
      String? supervisorId);
}
