import 'package:dartz/dartz.dart';
import 'package:sb_ap_audit_appv2/core/error/failures.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/entities/credentials.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/entities/user.dart';

import '../repositories/user_repository.dart';

class LoginUser {
  final UserRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, User?>?> execute(Credentials credentials) async {
    return await repository.login(credentials);
  }
}
