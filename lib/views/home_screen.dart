import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aliance_weather/controllers/weather_controller.dart';
import 'package:aliance_weather/controllers/location_controller.dart';
import 'package:aliance_weather/views/search_screen.dart';
import 'package:aliance_weather/views/widgets/current_weather_widget.dart';
import 'package:aliance_weather/views/widgets/forecast_widget.dart';
import 'package:aliance_weather/views/widgets/hourly_forecast_widget.dart';
import 'package:aliance_weather/views/widgets/sun_trajectory_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WeatherController weatherController;
  late LocationController locationController;

  @override
  void initState() {
    super.initState();
    weatherController = Get.find<WeatherController>();
    locationController = Get.find<LocationController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (weatherController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (weatherController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weatherController.errorMessage.value,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Retry loading weather data
                    weatherController.init();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            // Refresh weather data
            final position = await locationController.getCurrentLocation();
            if (position != null) {
              await weatherController.fetchWeatherByLocation(
                position.latitude,
                position.longitude,
              );
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current weather widget
                  CurrentWeatherWidget(
                    weather: weatherController.weatherData.value,
                  ),
                  const SizedBox(height: 30),

                  // Sun trajectory widget
                  SunTrajectoryWidget(
                    weather: weatherController.weatherData.value,
                  ),
                  const SizedBox(height: 30),

                  // Hourly forecast widget
                  HourlyForecastWidget(
                    hourlyData: weatherController.getNext24Hours(),
                    graphColor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 30),

                  // Forecast widget
                  ForecastWidget(
                    forecast: weatherController.forecastData.value,
                  ),
                  const SizedBox(height: 30),

                  // Use current location button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final position = await locationController
                            .getCurrentLocation();
                        if (position != null) {
                          await weatherController.fetchWeatherByLocation(
                            position.latitude,
                            position.longitude,
                          );
                        }
                      },
                      icon: const Icon(Icons.my_location),
                      label: const Text('Use Current Location'),
                    ),
                  ),

                  // Error message for location
                  Obx(() {
                    if (locationController.errorMessage.value.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          locationController.errorMessage.value,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
