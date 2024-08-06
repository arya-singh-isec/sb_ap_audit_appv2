import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class SelectionRepository {
  Future<Either<Failure, List<String>>> getFiscalYearData();
}
