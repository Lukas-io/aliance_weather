import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aliance_weather/config/constants/api_constants.dart';
import 'package:aliance_weather/models/weather_model.dart';
import 'package:aliance_weather/models/forecast_model.dart';

class WeatherService {
  final String baseUrl = ApiConstants.baseUrl;
  final String apiKey = ApiConstants.apiKey;

  /// Fetch current weather by latitude and longitude
  Future<WeatherModel?> getCurrentWeather(double lat, double lon) async {
    try {
      // Request astro data by setting aq=1 (air quality which includes astro data)
      final url = Uri.parse(
        '$baseUrl${ApiConstants.currentWeatherEndpoint}?key=$apiKey&q=$lat,$lon&aqi=yes',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load current weather data');
      }
    } catch (e) {
      throw Exception('Error fetching current weather: $e');
    }
  }

  /// Fetch forecast by latitude and longitude
  Future<ForecastModel?> getForecast(double lat, double lon) async {
    try {
      // Request hourly data by setting hourly=1 and specifying number of days
      final url = Uri.parse(
        '$baseUrl${ApiConstants.forecastEndpoint}?key=$apiKey&q=$lat,$lon&days=${ApiConstants.forecastDays}&hourly=1&aqi=yes',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ForecastModel.fromJson(data);
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      throw Exception('Error fetching forecast: $e');
    }
  }

  /// Search for weather by city name
  Future<WeatherModel?> searchCity(String cityName) async {
    try {
      final url = Uri.parse(
        '$baseUrl${ApiConstants.currentWeatherEndpoint}?key=$apiKey&q=$cityName&aqi=yes',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to search city weather data');
      }
    } catch (e) {
      throw Exception('Error searching city: $e');
    }
  }
}
