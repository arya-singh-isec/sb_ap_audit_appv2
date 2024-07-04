import  'package:dio/dio.dart';


class DioClient{
  final Dio _dio;
  DioClient(this._dio){
    _dio.options=BaseOptions(baseUrl: 'http://localhost:3000/api');
  }
  Future<Response>get(String endpoint) async {
    try{
      final response= await _dio.get(endpoint);
      return response;

    }catch(e){
      throw Exception('failed to load data');
    }
  }
}