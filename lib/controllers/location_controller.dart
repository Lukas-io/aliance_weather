import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:aliance_weather/services/location_service.dart';
import 'package:aliance_weather/utils/error_handler.dart';

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();

  var isLocationPermissionGranted = false.obs;
  var isLocationServiceEnabled = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeLocationStatus();
  }

  /// Initialize both permission & service status
  Future<void> _initializeLocationStatus() async {
    await checkPermissionStatus();
    await checkServiceStatus();
  }

  /// Check permission status
  Future<void> checkPermissionStatus() async {
    try {
      final permission = await _locationService.checkPermissionStatus();
      print(permission);

      isLocationPermissionGranted(
        permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse,
      );
    } catch (e) {
      errorMessage(ErrorHandler.handleLocationError(e));
    }
  }

  /// Check if location service (GPS) is enabled
  Future<void> checkServiceStatus() async {
    try {
      final enabled = await _locationService.isServiceEnabled();
      isLocationServiceEnabled(enabled);
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
      _initializeLocationStatus();
      errorMessage('');
      final position = await _locationService.getCurrentLocation();
      return position;
    } catch (e) {
      errorMessage(ErrorHandler.handleLocationError(e));
      return null;
    }
  }
}
