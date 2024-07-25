import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.isLoggedIn,
    required super.sessionToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['Success']['Id'],
        isLoggedIn: json['Success']['LoginFlag'] == 'Y',
        sessionToken: json['Success']['SessionToken']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'isLoggedIn': isLoggedIn, 'sessionToken': sessionToken};
  }
}
