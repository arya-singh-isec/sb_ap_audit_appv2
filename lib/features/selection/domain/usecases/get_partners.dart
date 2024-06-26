import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/partner.dart';
import '../repositories/partners_repository.dart';

class GetPartners {
  final PartnersRepository repository;

  GetPartners({required this.repository});

  Future<Either<Failure, List<Partner>?>?>? execute() async {
    return await repository.getPartners();
  }
}
