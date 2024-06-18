import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.id, required super.name, required super.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['data']['id'],
        name: json['data']['name'],
        email: json['data']['email']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}
