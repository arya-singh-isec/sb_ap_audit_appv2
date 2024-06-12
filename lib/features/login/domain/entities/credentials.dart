import 'package:equatable/equatable.dart';

class Credentials extends Equatable {
  final String username;
  final String password;

  const Credentials({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}
