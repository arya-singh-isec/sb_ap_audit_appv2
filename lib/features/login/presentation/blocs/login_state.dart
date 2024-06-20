import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

abstract class LoginState extends Equatable {
  const LoginState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoginEmpty extends LoginState {}

class LoginLoading extends LoginState {}

class LoginError extends LoginState {
  final String message;
  LoginError({required this.message}) : super([message]);
}

class LoginSuccess extends LoginState {
  final User? user;
  LoginSuccess({required this.user}) : super([user]);
}

class LogoutError extends LoginState {
  final String message;
  LogoutError({required this.message}) : super([message]);
}

class LogoutSuccess extends LoginState {}
