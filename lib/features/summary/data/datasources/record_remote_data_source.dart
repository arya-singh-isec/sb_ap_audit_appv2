import 'package:dio/dio.dart';
import '../models/record_model.dart';
import '../../../../core/network/dio_client.dart';



abstract class RecordRemoteDataSource {
  Future<List<RecordModel>> fetchRecords();
}

class RecordRemoteDataSourceImpl implements RecordRemoteDataSource {
  final DioClient dioClient;

  RecordRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<RecordModel>> fetchRecords() async {
    final response = await dioClient.get('/records');
    if (response.statusCode == 200) {
      final List data = response.data as List;
      return data.map((json) => RecordModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load records');
    }
  }
}