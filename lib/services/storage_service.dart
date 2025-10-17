import 'package:get_storage/get_storage.dart';

class StorageService {
  final _box = GetStorage();

  // Keys for storage
  static const String _lastLocationKey = 'last_location';
  static const String _lastLatKey = 'last_lat';
  static const String _lastLonKey = 'last_lon';

  /// Save last location (city name)
  Future<void> saveLastLocation(String cityName) async {
    await _box.write(_lastLocationKey, cityName);
  }

  /// Save last coordinates
  Future<void> saveLastCoordinates(double lat, double lon) async {
    await _box.write(_lastLatKey, lat);
    await _box.write(_lastLonKey, lon);
  }

  /// Get last location
  String? getLastLocation() {
    return _box.read(_lastLocationKey);
  }

  /// Get last coordinates
  ({double lat, double lon})? getLastCoordinates() {
    final lat = _box.read(_lastLatKey);
    final lon = _box.read(_lastLonKey);

    if (lat != null && lon != null) {
      return (lat: lat, lon: lon);
    }
    return null;
  }

  /// Clear saved location
  Future<void> clearLocation() async {
    await _box.remove(_lastLocationKey);
    await _box.remove(_lastLatKey);
    await _box.remove(_lastLonKey);
  }

  /// Check if any location is saved
  bool hasSavedLocation() {
    return _box.hasData(_lastLocationKey) ||
        (_box.hasData(_lastLatKey) && _box.hasData(_lastLonKey));
  }
}
