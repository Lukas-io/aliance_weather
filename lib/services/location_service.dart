import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Check if location services (GPS) are enabled
  Future<bool> isServiceEnabled() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      return serviceEnabled;
    } catch (e) {
      throw Exception('Error checking location service status: $e');
    }
  }

  /// Check current permission status
  Future<LocationPermission> checkPermissionStatus() async {
    try {
      final permission = await Geolocator.checkPermission();
      return permission;
    } catch (e) {
      throw Exception('Error checking location permission: $e');
    }
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      return permission;
    } catch (e) {
      throw Exception('Error requesting location permission: $e');
    }
  }

  /// Get current location (with internal checks)
  Future<Position> getCurrentLocation() async {
    try {
      final serviceEnabled = await isServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      var permission = await checkPermissionStatus();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      final position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      throw Exception('Error getting current location: $e');
    }
  }
}
