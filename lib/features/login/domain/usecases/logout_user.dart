import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/user_repository.dart';

class LogoutUser {
  final UserRepository repository;

  LogoutUser(this.repository);

  Future<Either<Failure, bool?>?>? execute() async {
    return await repository.logout();
  }
}
