class ErrorHandler {
  /// Handle API errors and return user-friendly messages
  static String handleApiError(dynamic error) {
    if (error.toString().contains('Failed to load')) {
      return 'Failed to fetch weather data. Please try again.';
    } else if (error.toString().contains('Invalid API key')) {
      return 'Invalid API key. Please check your configuration.';
    } else if (error.toString().contains('Rate limit')) {
      return 'Too many requests. Please try again later.';
    } else {
      return 'An error occurred while fetching weather data. Please try again.';
    }
  }

  /// Handle location errors
  static String handleLocationError(dynamic error) {
    if (error.toString().contains('Location services are disabled')) {
      return 'Location services are disabled. Please enable them in settings.';
    } else if (error.toString().contains('Location permissions are denied')) {
      return 'Location permission denied. Please allow location access to use this feature.';
    } else if (error.toString().contains(
      'Location permissions are permanently denied',
    )) {
      return 'Location permission permanently denied. Please enable it in app settings.';
    } else {
      return 'Unable to get current location. Please try searching for a city instead.';
    }
  }

  /// Handle network errors
  static String handleNetworkError() {
    return 'No internet connection. Please check your network and try again.';
  }
}
