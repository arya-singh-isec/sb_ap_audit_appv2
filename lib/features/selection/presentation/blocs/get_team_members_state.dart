import 'package:equatable/equatable.dart';

import '../../domain/entities/team_member.dart';

abstract class GetTeamMembersState extends Equatable {
  final List<Object?> _props;
  const GetTeamMembersState([this._props = const <Object?>[]]);

  @override
  List<Object?> get props => _props;
}

class TeamMembersEmpty extends GetTeamMembersState {}

class TeamMembersLoading extends GetTeamMembersState {}

class TeamMembersError extends GetTeamMembersState {
  final String message;

  TeamMembersError({required this.message}) : super([message]);
}

class TeamMembersHierarchyLoaded extends GetTeamMembersState {
  final List<TeamMember>? topLevelMembers;
  final Map<String, List<TeamMember>?>? subordinates;

  TeamMembersHierarchyLoaded(
      {required this.topLevelMembers, required this.subordinates})
      : super([topLevelMembers, subordinates]);
}
