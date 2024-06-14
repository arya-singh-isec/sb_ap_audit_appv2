class ServerException implements Exception {
  final int code;
  final String message;

  ServerException({this.code = 501, this.message = 'Server Error'});
}

class LocalException implements Exception {}
