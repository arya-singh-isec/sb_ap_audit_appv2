import 'package:dartz/dartz.dart';

import '../../features/login/domain/entities/credentials.dart';
import '../error/failures.dart';

class InputValidator {
  Either<Failure, Credentials>? validateCredentials(Credentials? credentials) {
    if (credentials!.username.isEmpty || credentials.password.isEmpty) {
      return Left(InvalidInputFailure());
    }
    return Right(credentials);
  }
}

class InvalidInputFailure extends Failure {}
