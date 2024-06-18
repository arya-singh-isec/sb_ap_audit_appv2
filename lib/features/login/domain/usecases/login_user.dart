import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/credentials.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class LoginUser {
  final UserRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, User?>?>? execute(Credentials? credentials) async {
    return await repository.login(credentials);
  }
}
