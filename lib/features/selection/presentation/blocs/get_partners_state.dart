import 'package:equatable/equatable.dart';
import '../../domain/entities/partner.dart';

abstract class GetPartnersState extends Equatable {
  const GetPartnersState([List props = const <dynamic>[]]);

  @override
  List<dynamic> get props => [];
}

class PartnersEmpty extends GetPartnersState {}

class PartnersLoading extends GetPartnersState {}

class PartnersLoaded extends GetPartnersState {
  final List<Partner>? partners;

  const PartnersLoaded({required this.partners});
}

class PartnersError extends GetPartnersState {
  final String message;

  const PartnersError({required this.message});
}
