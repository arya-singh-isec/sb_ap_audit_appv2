part of 'bloc.dart';

abstract class SelectionEvent extends Equatable {
  const SelectionEvent([List<dynamic> props = const <dynamic>[]]);

  @override
  List<Object?> get props => [];
}

class SelectionTypeChanged extends SelectionEvent {
  final SelectionType selectionType;

  SelectionTypeChanged({required this.selectionType}) : super([selectionType]);
}

class PartnerSelected extends SelectionEvent {
  final String partnerId;

  PartnerSelected(this.partnerId) : super([partnerId]);
}

class TeamMemberSelected extends SelectionEvent {
  final int level;
  final String? teamMemberId;

  TeamMemberSelected(this.teamMemberId, {required this.level})
      : super([level, teamMemberId]);
}

class FiscalYearSelected extends SelectionEvent {
  final String fiscalYear;

  FiscalYearSelected(this.fiscalYear) : super([fiscalYear]);
}

class FiscalPeriodSelected extends SelectionEvent {
  final String fiscalPeriod;

  FiscalPeriodSelected(this.fiscalPeriod) : super([fiscalPeriod]);
}

class SubmitSelection extends SelectionEvent {}
