import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final bool isLoggedIn;
  final String sessionToken;

  const User(
      {required this.id, required this.isLoggedIn, required this.sessionToken});

  @override
  List<Object?> get props => [id];
}
