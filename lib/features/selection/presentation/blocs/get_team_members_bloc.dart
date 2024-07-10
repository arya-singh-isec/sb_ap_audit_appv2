import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/entities/team_member.dart';
import '../../domain/usecases/get_subordinates.dart';
import '../../domain/usecases/get_team_members.dart';
import 'get_team_members_event.dart';
import 'get_team_members_state.dart';

class GetTeamMembersBloc extends Bloc<GetTeamMembersEvent, GetTeamMembersState>
    with BlocLoggy {
  final GetTeamMembers getTeamMembers;
  final GetSubordinates getSubordinates;

  GetTeamMembersBloc(
      {required this.getTeamMembers, required this.getSubordinates})
      : super(TeamMembersEmpty()) {
    on<FetchTeamMembersList>(_fetchTeamMembersList);
    on<FetchSubordinatesList>(_fetchSubordinatesList);
  }

  Future<void> _fetchTeamMembersList(
      FetchTeamMembersList event, Emitter<GetTeamMembersState> emit) async {
    emit(TeamMembersLoading());
    // const List<TeamMember> dummyList = [
    //   TeamMember(id: '1', name: 'TeamMember A', supervisorId: '23'),
    //   TeamMember(id: '2', name: 'TeamMember B', supervisorId: '54')
    // ];
    // emit(TeamMembersHierarchyLoaded(
    //     topLevelMembers: dummyList, subordinates: const {}));
    final result = await getTeamMembers.execute();
    result?.fold(
      (failure) {
        emit(TeamMembersError(
            message: failure is ServerFailure
                ? failure.message
                : 'Unexpected error!'));
      },
      (val) => emit(TeamMembersHierarchyLoaded(
          topLevelMembers: val, subordinates: const {})),
    );
  }

  Future<void> _fetchSubordinatesList(
      FetchSubordinatesList event, Emitter<GetTeamMembersState> emit) async {
    // final prevState = state as TeamMembersHierarchyLoaded;
    // emit(TeamMembersLoading());
    // const List<TeamMember> dummyList = [
    //   TeamMember(id: '3', name: 'TeamMember AA', supervisorId: '1'),
    //   TeamMember(id: '4', name: 'TeamMember AB', supervisorId: '1'),
    //   TeamMember(id: '5', name: 'TeamMember AA1', supervisorId: '3'),
    //   TeamMember(id: '6', name: 'TeamMember AA2', supervisorId: '3'),
    //   TeamMember(id: '7', name: 'TeamMember AB1', supervisorId: '4'),
    //   TeamMember(id: '8', name: 'TeamMember AB2', supervisorId: '4'),
    // ];
    // List<TeamMember> dummyTeamMembers = [];
    // for (int i = 0; i < dummyList.length; i++) {
    //   if (dummyList[i].supervisorId == event.supervisorId) {
    //     dummyTeamMembers.add(dummyList[i]);
    //   }
    // }
    // final newSubordinates = Map<String, List<TeamMember>?>.from(
    //     prevState.subordinates as Map<String, List<TeamMember>?>);
    // newSubordinates[event.supervisorId as String] = dummyTeamMembers;
    // emit(
    //   TeamMembersHierarchyLoaded(
    //     topLevelMembers: prevState.topLevelMembers,
    //     subordinates: newSubordinates,
    //   ),
    // );
    final prevState = state;
    if (prevState is! TeamMembersHierarchyLoaded) return;
    emit(TeamMembersLoading());

    final result = await getSubordinates.execute(event.supervisorId);
    result?.fold((failure) {
      emit(TeamMembersError(
          message: failure is ServerFailure
              ? failure.message
              : 'Unexpected error!'));
    }, (val) {
      final newSubordinates = Map<String, List<TeamMember>?>.from(
          prevState.subordinates as Map<String, List<TeamMember>?>);
      newSubordinates[event.supervisorId as String] = val;
      emit(TeamMembersHierarchyLoaded(
          topLevelMembers: prevState.topLevelMembers,
          subordinates: newSubordinates));
    });
  }
}
