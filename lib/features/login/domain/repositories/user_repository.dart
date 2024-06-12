import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/credentials.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> login(Credentials credentials);
  Future<Either<Failure, void>> logout();
}
