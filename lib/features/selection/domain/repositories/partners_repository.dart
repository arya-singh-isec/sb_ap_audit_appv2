import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/partner.dart';

abstract class PartnersRepository {
  // Added Null subtypes for unit tests
  Future<Either<Failure, List<Partner>?>?>? getPartners();
}
