part of 'bloc.dart';

abstract class GetPartnersEvent extends Equatable {
  const GetPartnersEvent([List<dynamic> props = const <dynamic>[]]);

  @override
  List<dynamic> get props => [];
}

class FetchPartnersList extends GetPartnersEvent {}
