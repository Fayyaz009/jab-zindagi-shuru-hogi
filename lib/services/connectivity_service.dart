import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  
  // Stream to listen for connectivity changes
  Stream<ConnectivityStatus> get connectivityStream =>
      _connectivity.onConnectivityChanged.map((results) {
        // results is a List<ConnectivityResult> in version 6.x
        if (results.contains(ConnectivityResult.none)) {
          return ConnectivityStatus.offline;
        }
        return ConnectivityStatus.online;
      });

  Future<ConnectivityStatus> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.none)) {
      return ConnectivityStatus.offline;
    }
    return ConnectivityStatus.online;
  }
}
