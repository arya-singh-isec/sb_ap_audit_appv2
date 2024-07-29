import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/usecases/get_partners.dart';
import 'get_partners_event.dart';
import 'get_partners_state.dart';

class GetPartnersBloc extends Bloc<GetPartnersEvent, GetPartnersState>
    with BlocLoggy {
  final GetPartners getPartners;

  GetPartnersBloc({required this.getPartners}) : super(PartnersEmpty()) {
    on<FetchPartnersList>(_fetchPartnersList);
  }

  Future<void> _fetchPartnersList(
      FetchPartnersList event, Emitter<GetPartnersState> emit) async {
    emit(PartnersLoading());
    final result = await getPartners.execute();
    result?.fold(
      (failure) {
        emit(
          PartnersError(
            message: failure is ServerFailure
                ? failure.message
                : 'Unexpected Error!',
          ),
        );
      },
      (val) => emit(PartnersLoaded(partners: val)),
    );
  }
}
