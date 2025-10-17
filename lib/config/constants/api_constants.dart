class ApiConstants {
  // TODO: Replace with your actual WeatherAPI key
  static const String apiKey = "";
  static const String baseUrl = "https://api.weatherapi.com/v1";

  // API Endpoints
  static const String currentWeatherEndpoint = "/current.json";
  static const String forecastEndpoint = "/forecast.json";

  // Query parameters
  static const int forecastDays = 5;
}
