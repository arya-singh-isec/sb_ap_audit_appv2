class ServerException implements Exception {
  final int code;
  final String message;

  ServerException({this.code = 501, this.message = 'Server Error'});
}

class NetworkException implements Exception {}

class LocalException implements Exception {}
