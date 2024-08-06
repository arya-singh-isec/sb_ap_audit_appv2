part of 'bloc.dart';

abstract class GetFiscalYearState extends Equatable {
  const GetFiscalYearState([List<dynamic> props = const <dynamic>[]]);

  @override
  List<Object?> get props => [];
}

class FiscalYearDataInitial extends GetFiscalYearState {}

class FiscalYearDataLoading extends GetFiscalYearState {}

class FiscalYearDataLoaded extends GetFiscalYearState {
  final List<String> fiscalYears;

  const FiscalYearDataLoaded({required this.fiscalYears});
}

class FiscalYearDataError extends GetFiscalYearState {
  final String message;

  const FiscalYearDataError({required this.message});
}
