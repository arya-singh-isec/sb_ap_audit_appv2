import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/team_member.dart';
import '../../domain/repositories/team_members_repository.dart';
import '../datasources/team_members_remote_data_source.dart';

class TeamMembersRepositoryImpl implements TeamMembersRepository {
  final TeamMembersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TeamMembersRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<TeamMember>?>?>? getTeamMembers() async {
    await networkInfo.isConnected;
    try {
      final response = await remoteDataSource.getTeamMembers();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<TeamMember>?>?>? getSubordinates(
      String? supervisorId) async {
    await networkInfo.isConnected;
    try {
      final response = await remoteDataSource.getSubordinates(supervisorId);
      return Right(response);
    } on ServerException catch (e) {
      if (e.code == 404) {
        return const Right([]);
      }
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }
}
