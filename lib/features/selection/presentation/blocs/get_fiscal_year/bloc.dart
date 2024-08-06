import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/logger/logger.dart';
import '../../../domain/usecases/get_fiscal_year_data.dart';

part 'get_fiscal_year_event.dart';
part 'get_fiscal_year_state.dart';

class GetFiscalYearBloc extends Bloc<GetFiscalYearEvent, GetFiscalYearState>
    with BlocLoggy {
  final GetFiscalYearData getFiscalYearData;

  GetFiscalYearBloc({required this.getFiscalYearData})
      : super(FiscalYearDataInitial()) {
    on<FetchFiscalYearList>(_onFetchFiscalYearList);
  }

  void _onFetchFiscalYearList(
      FetchFiscalYearList event, Emitter<GetFiscalYearState> emit) async {
    emit(FiscalYearDataLoading());
    final result = await getFiscalYearData.execute();
    result.fold((failure) {
      emit(
        FiscalYearDataError(
          message:
              failure is ServerFailure ? failure.message : 'Unexpected error!',
        ),
      );
    }, (val) => emit(FiscalYearDataLoaded(fiscalYears: val)));
  }
}
