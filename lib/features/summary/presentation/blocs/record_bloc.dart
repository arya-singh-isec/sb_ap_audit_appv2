// lib/presentation/bloc/record_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/record.dart';
import '../../domain/usecases/get_record_data.dart';

abstract class RecordState {}

class RecordInitial extends RecordState {}

class RecordLoading extends RecordState {}

class RecordLoaded extends RecordState {
  final List<Record> records;

  RecordLoaded(this.records);
}

class RecordError extends RecordState {
  final String message;

  RecordError(this.message);
}

class RecordCubit extends Cubit<RecordState> {
  final GetRecords getRecords;

  RecordCubit({required this.getRecords}) : super(RecordInitial());

  Future<void> fetchRecords() async {
    try {
      emit(RecordLoading());
      final records = await getRecords();
      emit(RecordLoaded(records));
    } catch (e) {
      emit(RecordError(e.toString()));
    }
  }
}
