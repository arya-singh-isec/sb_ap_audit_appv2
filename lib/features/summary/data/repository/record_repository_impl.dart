

import '../../domain/entities/record.dart';
import '../../domain/repositories/record_repository.dart';
import '../datasources/record_remote_data_source.dart';

class RecordRepositoryImpl implements RecordRepository {
  final RecordRemoteDataSource remoteDataSource;

  RecordRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Record>> getRecords() async {
    return await remoteDataSource.fetchRecords();
  }
}









