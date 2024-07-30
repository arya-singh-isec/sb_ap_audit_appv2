// lib/domain/repositories/record_repository.dart
import 'package:dartz/dartz.dart';
import 'package:sb_ap_audit_appv2/core/error/failures.dart';

import '../entities/summary.dart';

abstract class SummaryRepository {
  Future<Either<Failure,List<Summary>?>>getSummarys();

}
