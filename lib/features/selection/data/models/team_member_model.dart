import '../../domain/entities/team_member.dart';

class TeamMemberModel extends TeamMember {
  const TeamMemberModel(
      {required super.id, required super.name, required super.supervisorId});

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
        id: json['data']['id'],
        name: json['data']['name'],
        supervisorId: json['data']['supervisorId']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "supervisorId": supervisorId};
  }
}
