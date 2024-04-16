// connectivity_service.dart

import 'dart:async';
import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  late StreamSubscription<ConnectivityResult> _subscription;

  ConnectivityService() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      // Broadcast the connectivity result to subscribers
      _controller.add(result);
    });
  }

  StreamController<ConnectivityResult> _controller = StreamController<ConnectivityResult>.broadcast();

  Stream<ConnectivityResult> get onConnectivityChanged => _controller.stream;

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}
