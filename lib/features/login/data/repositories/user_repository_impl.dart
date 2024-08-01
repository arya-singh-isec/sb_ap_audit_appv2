import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_service.dart';
import '../../domain/entities/credentials.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkService networkService;

  UserRepositoryImpl(
      {required this.remoteDataSource, required this.networkService});

  @override
  Future<Either<Failure, User?>> login(Credentials? credentials) async {
    try {
      if (!(await networkService.isConnected)!) {
        throw NetworkException();
      }
      final loginResponse = await remoteDataSource.login(credentials);
      return Right(loginResponse);
    } on Exception catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(code: e.code, message: e.message));
      } else if (e is NetworkException) {
        return Left(NetworkFailure());
      }
      return Left(ServerFailure(
          code: 500, message: 'Server error. Please try again later!'));
    }
    // local storage (cache) implementation is pending
  }

  @override
  Future<Either<Failure, bool?>> logout() async {
    if (!(await networkService.isConnected)!) {
      throw NetworkException();
    }
    try {
      final logoutResponse = await remoteDataSource.logout();
      return Right(logoutResponse);
    } on Exception catch (e) {
      if (e is NetworkException) {
        return Left(NetworkFailure());
      }
      final error = e as ServerException;
      return Left(ServerFailure(code: error.code, message: error.message));
    }
  }
}
