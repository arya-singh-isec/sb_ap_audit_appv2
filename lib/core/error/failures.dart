import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;
  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object?> get props => properties;
}

// Failures will map one-to-one with exceptions
class ServerFailure extends Failure {
  final int code;
  final String message;

  ServerFailure({required this.code, required this.message})
      : super([code, message]);
}

class NetworkFailure extends Failure {}

class LocalFailure extends Failure {}
