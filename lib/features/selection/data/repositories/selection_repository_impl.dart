import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_service.dart';
import '../../domain/repositories/selection_repository.dart';
import '../datasources/selection_remote_data_source.dart';

class SelectionRepositoryImpl implements SelectionRepository {
  final NetworkService networkService;
  final SelectionRemoteDataSource remoteDataSource;

  SelectionRepositoryImpl(
      {required this.remoteDataSource, required this.networkService});

  @override
  Future<Either<Failure, List<String>>> getFiscalYearData() async {
    try {
      if (!(await networkService.isConnected)!) {
        throw NetworkException();
      }
      final response = await remoteDataSource.getFiscalYearData();
      return Right(response);
    } on Exception catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(code: e.code, message: e.message));
      } else if (e is NetworkException) {
        return Left(NetworkFailure());
      }
      return Left(
        ServerFailure(
            code: 500, message: 'Server error. Please try again later!'),
      );
    }
  }
}
