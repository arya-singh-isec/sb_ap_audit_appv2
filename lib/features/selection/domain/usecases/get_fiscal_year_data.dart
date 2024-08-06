import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/selection_repository.dart';

class GetFiscalYearData {
  final SelectionRepository repository;

  GetFiscalYearData({required this.repository});

  Future<Either<Failure, List<String>>> execute() async {
    return await repository.getFiscalYearData();
  }
}
