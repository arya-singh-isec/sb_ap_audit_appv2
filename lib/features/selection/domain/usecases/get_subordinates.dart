import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/team_member.dart';
import '../repositories/team_members_repository.dart';

class GetSubordinates {
  final TeamMembersRepository repository;

  GetSubordinates({required this.repository});

  Future<Either<Failure, List<TeamMember>?>?>? execute(
      String? supervisorId) async {
    return await repository.getSubordinates(supervisorId);
  }
}
