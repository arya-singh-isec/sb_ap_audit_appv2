import 'package:equatable/equatable.dart';

abstract class GetTeamMembersEvent extends Equatable {
  const GetTeamMembersEvent([List props = const <dynamic>[]]);

  @override
  List<dynamic> get props => [];
}

class FetchTeamMembersList extends GetTeamMembersEvent {}

/// Subordinates are equivalent to [TeamMember].
class FetchSubordinatesList extends GetTeamMembersEvent {
  final String? supervisorId;
  FetchSubordinatesList({required this.supervisorId}) : super([supervisorId]);
}
