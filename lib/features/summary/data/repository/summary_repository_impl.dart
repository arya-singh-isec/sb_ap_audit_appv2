import 'package:dartz/dartz.dart';
// import 'package:sb_ap_audit_appv2/features/summary/domain/entities/summary.dart';
import 'package:sb_ap_audit_appv2/features/summary/domain/repositories/summary_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_service.dart';
import '../../data/models/summary_model.dart';
import '../datasources/summary_remote_data_source.dart';

class SummaryRepositoryImpl implements SummaryRepository {
  final SummaryRemoteDataSource remoteDataSource;
  final NetworkService networkService;

  SummaryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkService,
  });

  @override
  Future<Either<Failure, List<SummaryModel>?>> getSummarys() async {
    await networkService.isConnected;
    try {
      final response = await remoteDataSource.getSummary();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    }
  }
}
