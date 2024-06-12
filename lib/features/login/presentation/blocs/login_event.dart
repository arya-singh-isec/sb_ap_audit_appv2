abstract class LoginEvent {}

class UsernameChanged extends LoginEvent {
  final String username;
  UsernameChanged({required this.username});
}

class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged({required this.password});
}

class Submitted extends LoginEvent {}
