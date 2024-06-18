import 'package:equatable/equatable.dart';

import '../../domain/entities/credentials.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class UsernameChanged extends LoginEvent {
  final String username;
  const UsernameChanged({required this.username});
}

class PasswordChanged extends LoginEvent {
  final String password;
  const PasswordChanged({required this.password});
}

class Submitted extends LoginEvent {
  final Credentials? credentials;
  const Submitted({this.credentials});
}
