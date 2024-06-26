import 'package:equatable/equatable.dart';

class TeamMember extends Equatable {
  final String id;
  final String name;
  final String supervisorId;

  const TeamMember(
      {required this.id, required this.name, required this.supervisorId});

  @override
  List<Object?> get props => [id, name, supervisorId];
}
