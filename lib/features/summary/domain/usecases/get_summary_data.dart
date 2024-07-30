


// lib/domain/usecases/get_records.dart
import 'package:dartz/dartz.dart';
import 'package:sb_ap_audit_appv2/core/error/failures.dart';

import '../entities/summary.dart';
import '../repositories/summary_repository.dart';

class GetSummarys {
  final SummaryRepository repository;

  GetSummarys({required this.repository});
 Future<Either<Failure,List<Summary>?>> call() async{
      return await repository.getSummarys();
 }
}
