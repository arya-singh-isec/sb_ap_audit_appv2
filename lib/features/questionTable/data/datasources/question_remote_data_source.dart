// lib/features/question/data/datasources/question_remote_data_source.dart
import 'dart:convert';
import '../../../../core/network/dio_client.dart';
import '../models/question_model.dart';

abstract class QuestionRemoteDataSource {
  Future<List<QuestionModel>> fetchQuestions();
}

class QuestionRemoteDataSourceImpl implements QuestionRemoteDataSource {
  final DioClient dioClient;

  QuestionRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<QuestionModel>> fetchQuestions() async {
    final response = await dioClient.get('/questions');
    if(response.statusCode==200){
 final List data = response.data as  List;
  return data.map((question) => QuestionModel.fromJson(question)).toList();
    }
    else {
      throw Exception('failed to load records');
    }  
  }
}
