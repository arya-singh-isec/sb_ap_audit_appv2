// lib/domain/usecases/get_records.dart
import '../entities/record.dart';
import '../repositories/record_repository.dart';

class GetRecords {
  final RecordRepository repository;

  GetRecords(this.repository);

  Future<List<Record>> call() async {
    return await repository.getRecords();
  }
}
