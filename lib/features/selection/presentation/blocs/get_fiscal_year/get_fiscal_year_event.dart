part of 'bloc.dart';

abstract class GetFiscalYearEvent extends Equatable {
  const GetFiscalYearEvent([List<dynamic> props = const <dynamic>[]]);

  @override
  List<Object?> get props => [];
}

class FetchFiscalYearList extends GetFiscalYearEvent {}
