import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'network_info.dart';

class NetworkService {
  final NetworkInfo _networkInfo;
  bool _isInitialCheck = true;

  NetworkService() : _networkInfo = NetworkInfoImpl();

  Stream<bool?> get connectivityStream => _networkInfo.connectivityStream!
      .map((event) {
        bool isConnected = event == InternetConnectionStatus.connected;
        if (_isInitialCheck) {
          _isInitialCheck = false;
          return isConnected ? null : false;
        }
        return isConnected;
      })
      .where((event) => event != null)
      .cast<bool>();

  Future<bool?> get isConnected => _networkInfo.isConnected!;
}
