// lib/presentation/bloc/record_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sb_ap_audit_appv2/core/error/failures.dart';
import '../../domain/entities/summary.dart';
import '../../domain/usecases/get_summary_data.dart';

abstract class SummaryState {}

class SummaryInitial extends SummaryState {}

class SummaryLoading extends SummaryState {}

class SummaryLoaded extends SummaryState {
  final Either<Failure,List<Summary>?> records;

  SummaryLoaded(this.records);
}

class SummaryError extends SummaryState {
  final String message;

  SummaryError(this.message);
}

class SummaryCubit extends Cubit<SummaryState> {
  final GetSummarys getSummarys;

  SummaryCubit({required this.getSummarys}) : super(SummaryInitial());

  Future<void> fetchSummarys() async {
    try {
      emit(SummaryLoading());
      final records = await getSummarys();
      emit(SummaryLoaded(records));
    } catch (e) {
      emit(SummaryError(e.toString()));
    }
  }
}

