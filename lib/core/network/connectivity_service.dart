import 'package:connectivity_plus/connectivity_plus.dart';

/// Wraps `connectivity_plus` to abstract device network state checking.
///
/// Enables fail-fast behavior in the network layer: if the device is known
/// to be offline, the [ApiClient] can immediately return a [NoInternetError]
/// instead of waiting for a network timeout.
class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Returns `true` if the device has an active network connection.
  ///
  /// Note: A true result indicates a connection to a network (Wi-Fi, Cellular),
  /// but does not guarantee that the internet is actually reachable (e.g.,
  /// captive portals or dead ISP connections).
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    // Using contains since result is now a List<ConnectivityResult> in newer versions
    return !result.contains(ConnectivityResult.none);
  }

  /// Reactive stream of connectivity changes.
  ///
  /// Emits `true` when connected, `false` when disconnected.
  /// Used by [OfflineBanner] to react to network state transitions.
  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.map(
      (results) => !results.contains(ConnectivityResult.none),
    );
  }
}

