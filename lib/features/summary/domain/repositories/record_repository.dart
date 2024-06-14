// lib/domain/repositories/record_repository.dart
import '../entities/record.dart';

abstract class RecordRepository {
  Future<List<Record>> getRecords();
}
