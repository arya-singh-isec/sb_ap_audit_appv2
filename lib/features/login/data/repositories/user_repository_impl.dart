import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/credentials.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, User?>> login(Credentials? credentials) async {
    await networkInfo.isConnected;
    try {
      final loginResponse = await remoteDataSource.login(credentials);
      return Right(loginResponse);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
    // local storage (cache) implementation is pending
  }

  @override
  Future<Either<Failure, bool?>> logout() async {
    await networkInfo.isConnected;
    try {
      final logoutResponse = await remoteDataSource.logout();
      return Right(logoutResponse);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }
}
