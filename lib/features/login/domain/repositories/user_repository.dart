import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/credentials.dart';
import '../entities/user.dart';

abstract class UserRepository {
  // Added Null subtype for tests
  Future<Either<Failure, User?>?>? login(Credentials credentials);

  // Return a boolean on successful logout/we can create a Success type as well
  Future<Either<Failure, bool?>?>? logout();
}
