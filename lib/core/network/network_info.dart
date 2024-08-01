import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool?>? get isConnected;
  Stream<InternetConnectionStatus>? get connectivityStream;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl() : connectionChecker = InternetConnectionChecker();

  @override
  Future<bool?>? get isConnected => connectionChecker.hasConnection;

  @override
  Stream<InternetConnectionStatus>? get connectivityStream =>
      connectionChecker.onStatusChange;
}
