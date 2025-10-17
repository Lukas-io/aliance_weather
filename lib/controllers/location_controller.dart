import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:aliance_weather/services/location_service.dart';
import 'package:aliance_weather/utils/error_handler.dart';

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();

  var isLocationPermissionGranted = false.obs;
  var isLocationServiceEnabled = false.obs;
  var errorMessage = ''.obs;

  /// Check permission status
  Future<void> checkPermissionStatus() async {
    try {
      final permission = await _locationService.checkPermissionStatus();
      isLocationPermissionGranted(
        permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse,
      );
    } catch (e) {
      errorMessage(ErrorHandler.handleLocationError(e));
    }
  }

  /// Request location permission
  Future<void> requestLocationPermission() async {
    try {
      errorMessage('');
      final permission = await _locationService.requestPermission();
      isLocationPermissionGranted(
        permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse,
      );
    } catch (e) {
      errorMessage(ErrorHandler.handleLocationError(e));
    }
  }

  /// Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      errorMessage('');
      final position = await _locationService.getCurrentLocation();
      return position;
    } catch (e) {
      errorMessage(ErrorHandler.handleLocationError(e));
      return null;
    }
  }
}
