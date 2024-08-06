part of 'bloc.dart';

enum SelectionType { partner, teamMember }

class SelectionState extends Equatable {
  final SelectionType? selectionType;
  final String? selectedPartner;
  final List<String>? teamMemberIds;
  final String? fiscalYear;
  final String? fiscalPeriod;

  const SelectionState({
    this.selectionType,
    this.selectedPartner,
    this.teamMemberIds = const [],
    this.fiscalYear,
    this.fiscalPeriod,
  });

  factory SelectionState.initial() => const SelectionState();

  SelectionState copyWith({
    SelectionType? selectionType,
    String? partnerId,
    List<String>? teamMemberIds,
    String? fiscalYear,
    String? fiscalPeriod,
  }) =>
      SelectionState(
        selectionType: selectionType ?? this.selectionType,
        selectedPartner: partnerId ?? selectedPartner,
        teamMemberIds: teamMemberIds ?? this.teamMemberIds,
        fiscalYear: fiscalYear ?? this.fiscalYear,
        fiscalPeriod: fiscalPeriod ?? this.fiscalPeriod,
      );

  @override
  List<Object?> get props =>
      [selectionType, selectedPartner, teamMemberIds, fiscalYear, fiscalPeriod];
}
