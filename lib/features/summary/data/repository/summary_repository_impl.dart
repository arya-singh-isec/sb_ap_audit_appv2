import 'package:dartz/dartz.dart';
import 'package:sb_ap_audit_appv2/core/error/exceptions.dart';
import 'package:sb_ap_audit_appv2/core/error/failures.dart';
import 'package:sb_ap_audit_appv2/core/network/network_info.dart';
import 'package:sb_ap_audit_appv2/features/summary/data/datasources/summary_remote_data_source.dart';
// import 'package:sb_ap_audit_appv2/features/summary/domain/entities/summary.dart';
import 'package:sb_ap_audit_appv2/features/summary/domain/repositories/summary_repository.dart';
import '../../data/models/summary_model.dart';

class SummaryRepositoryImpl implements SummaryRepository {
  final SummaryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SummaryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SummaryModel>?>> getSummarys() async {
   await networkInfo.isConnected;
   try {
    final response=await remoteDataSource.getSummary();
    return Right(response);
   }on ServerException catch (e){
    return Left(ServerFailure(code: e.code, message: e.message));
   }
  }
}
