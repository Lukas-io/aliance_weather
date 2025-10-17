import 'package:get/get.dart';
import 'package:aliance_weather/controllers/weather_controller.dart';
import 'package:aliance_weather/controllers/location_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Lazy loading of controllers
    Get.lazyPut(() => WeatherController());
    Get.lazyPut(() => LocationController());
  }
}
