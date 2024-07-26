import 'package:dio/dio.dart';
import '../config/constants.dart';

class DioClient {
  final Dio dio;

  DioClient(this.dio) {
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Perform actions before the request is sent
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Perform actions on the response data
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        // Perform actions on request errors
        return handler.next(error);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return dio.post(path, data: data);
  }
}
