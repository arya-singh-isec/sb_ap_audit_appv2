import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_service.dart';
import '../../domain/entities/partner.dart';
import '../../domain/repositories/partners_repository.dart';
import '../datasources/partners_remote_data_source.dart';

class PartnersRepositoryImpl implements PartnersRepository {
  final PartnersRemoteDataSource remoteDataSource;
  final NetworkService networkService;

  PartnersRepositoryImpl(
      {required this.remoteDataSource, required this.networkService});

  @override
  Future<Either<Failure, List<Partner>?>?>? getPartners() async {
    await networkService.isConnected;
    try {
      final response = await remoteDataSource.getPartners();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }
}
