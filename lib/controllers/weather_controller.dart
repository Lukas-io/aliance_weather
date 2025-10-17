import 'package:get/get.dart';
import 'package:aliance_weather/models/weather_model.dart';
import 'package:aliance_weather/models/forecast_model.dart' as forecast;
import 'package:aliance_weather/services/weather_service.dart';
import 'package:aliance_weather/services/storage_service.dart';
import 'package:aliance_weather/utils/error_handler.dart';

class WeatherController extends GetxController {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();

  // Reactive variables
  var weatherData = WeatherModel(
    location: Location(name: '', lat: 0.0, lon: 0.0),
    current: Current(
      temp: 0.0,
      condition: WeatherCondition(text: '', icon: '', code: 0),
      humidity: 0,
      windSpeed: 0.0,
      icon: '',
      feelsLike: 0.0,
    ),
    lastUpdated: DateTime.now(),
  ).obs;

  var forecastData = forecast.ForecastModel(forecastDays: []).obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  /// Initialize the controller
  Future<void> init() async {
    // Default to Lagos coordinates if no saved location
    double lat = 6.5244;
    double lon = 3.3792;

    // Check if we have a saved location
    if (_storageService.hasSavedLocation()) {
      final coords = _storageService.getLastCoordinates();
      if (coords != null) {
        lat = coords.lat;
        lon = coords.lon;
      }
    }

    await fetchWeatherByLocation(lat, lon);
  }

  /// Fetch weather by location coordinates
  Future<void> fetchWeatherByLocation(double lat, double lon) async {
    try {
      isLoading(true);
      errorMessage('');

      final weather = await _weatherService.getCurrentWeather(lat, lon);
      if (weather != null) {
        weatherData(weather);
        _storageService.saveLastCoordinates(lat, lon);

        // Fetch forecast after getting current weather
        await _fetchForecast(lat, lon);
      }
    } catch (e) {
      errorMessage(ErrorHandler.handleApiError(e));
    } finally {
      isLoading(false);
    }
  }

  /// Fetch weather by city name
  Future<void> fetchWeatherByCity(String cityName) async {
    try {
      isLoading(true);
      errorMessage('');

      final weather = await _weatherService.searchCity(cityName);
      if (weather != null) {
        weatherData(weather);
        _storageService.saveLastLocation(cityName);

        // Fetch forecast after getting current weather
        await _fetchForecast(weather.location.lat, weather.location.lon);
      }
    } catch (e) {
      errorMessage(ErrorHandler.handleApiError(e));
    } finally {
      isLoading(false);
    }
  }

  /// Private method to fetch forecast
  Future<void> _fetchForecast(double lat, double lon) async {
    try {
      final forecastDataModel = await _weatherService.getForecast(lat, lon);
      if (forecastDataModel != null) {
        forecastData(forecastDataModel);
      }
    } catch (e) {
      // We don't set error message here as we still want to show current weather
      // even if forecast fails
    }
  }

  /// Search weather by query (city name)
  Future<void> searchWeather(String query) async {
    if (query.isEmpty) return;
    await fetchWeatherByCity(query);
  }
}
