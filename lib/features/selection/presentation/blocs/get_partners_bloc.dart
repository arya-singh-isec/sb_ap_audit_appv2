import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
// import '../../domain/entities/partner.dart';
import '../../domain/usecases/get_partners.dart';
import 'get_partners_event.dart';
import 'get_partners_state.dart';

class GetPartnersBloc extends Bloc<GetPartnersEvent, GetPartnersState> {
  final GetPartners getPartners;

  GetPartnersBloc({required this.getPartners}) : super(PartnersEmpty()) {
    on<FetchPartnersList>(_fetchPartnersList);
  }

  Future<void> _fetchPartnersList(
      FetchPartnersList event, Emitter<GetPartnersState> emit) async {
    emit(PartnersLoading());
    // final List<Partner> dummyListOfPartners = [
    //   Partner(id: '1', name: 'RAMU 08977'),
    //   Partner(id: '2', name: 'BHAU 16492')
    // ];
    // emit(PartnersLoaded(partners: dummyListOfPartners));
    final result = await getPartners.execute();
    result?.fold(
      (failure) {
        emit(
          PartnersError(
            message: failure is ServerFailure
                ? 'Server Error!'
                : 'Unexpected Error!',
          ),
        );
      },
      (val) => emit(PartnersLoaded(partners: val)),
    );
  }
}
