import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'submit_selection_event.dart';
part 'submit_selection_state.dart';

class SelectionBloc extends Bloc<SelectionEvent, SelectionState> {
  SelectionBloc() : super(SelectionState.initial()) {
    on<SelectionTypeChanged>(_onSelectionTypeChanged);
    on<PartnerSelected>(_onPartnerSelected);
    on<TeamMemberSelected>(_onTeamMemberSelected);
    on<FiscalYearSelected>(_onFiscalYearSelected);
    on<FiscalPeriodSelected>(_onFiscalPeriodSelected);
    on<SubmitSelection>(_onSubmitSelection);
  }

  void _onSelectionTypeChanged(
      SelectionTypeChanged event, Emitter<SelectionState> emit) {
    emit(state.copyWith(
      selectionType: event.selectionType,
    ));
  }

  void _onPartnerSelected(PartnerSelected event, Emitter<SelectionState> emit) {
    emit(state.copyWith(
      partnerId: event.partnerId,
    ));
  }

  void _onTeamMemberSelected(
      TeamMemberSelected event, Emitter<SelectionState> emit) {
    final newTeamMemberIds = List<String>.from(state.teamMemberIds!);
    if (event.level >= newTeamMemberIds.length) {
      newTeamMemberIds.add(event.teamMemberId!);
    } else {
      newTeamMemberIds[event.level] = event.teamMemberId!;
      newTeamMemberIds.removeRange(event.level + 1, newTeamMemberIds.length);
    }
    emit(state.copyWith(teamMemberIds: newTeamMemberIds));
  }

  void _onFiscalYearSelected(
      FiscalYearSelected event, Emitter<SelectionState> emit) {
    emit(state.copyWith(
      fiscalYear: event.fiscalYear,
    ));
  }

  void _onFiscalPeriodSelected(
      FiscalPeriodSelected event, Emitter<SelectionState> emit) {
    emit(state.copyWith(
      fiscalPeriod: event.fiscalPeriod,
    ));
  }

  void _onSubmitSelection(SubmitSelection event, Emitter<SelectionState> emit) {
    // TODO: Unimplemented
  }
}
