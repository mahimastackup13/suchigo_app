import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  bool isLoading = false;
  Position? currentPosition;
  String? errorMessage;

  /// Request permission and get user location
  Future<void> fetchLocation() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        errorMessage = "Location permission permanently denied.";
        isLoading = false;
        notifyListeners();
        return;
      }

      // Get current position
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = "Failed to get location: $e";
      isLoading = false;
      notifyListeners();
    }
  }

  double? get latitude => currentPosition?.latitude;
  double? get longitude => currentPosition?.longitude;
}
