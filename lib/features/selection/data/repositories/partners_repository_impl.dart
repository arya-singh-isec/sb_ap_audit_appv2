import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/partners_repository.dart';
import '../datasources/partners_remote_data_source.dart';
import '../models/partner_model.dart';

class PartnersRepositoryImpl implements PartnersRepository {
  final PartnersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PartnersRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<PartnerModel>?>?>? getPartners() async {
    await networkInfo.isConnected;
    try {
      final response = await remoteDataSource.getPartners();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }
}
