import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aliance_weather/controllers/weather_controller.dart';
import 'package:aliance_weather/controllers/location_controller.dart';
import 'package:aliance_weather/views/widgets/current_weather_widget.dart';
import 'package:aliance_weather/views/widgets/location_input_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late WeatherController weatherController;
  late LocationController locationController;

  @override
  void initState() {
    super.initState();
    weatherController = Get.put(WeatherController());
    locationController = Get.put(LocationController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Location')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationInputWidget(
              onSearch: (query) {
                if (query.isNotEmpty) {
                  weatherController.searchWeather(query);
                }
              },
            ),
            const SizedBox(height: 20),

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

            const SizedBox(height: 30),

            // Display weather data if available
            Obx(() {
              if (weatherController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (weatherController.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Text(
                    weatherController.errorMessage.value,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (weatherController
                  .weatherData
                  .value
                  .location
                  .name
                  .isNotEmpty) {
                return CurrentWeatherWidget(
                  weather: weatherController.weatherData.value,
                );
              }

              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
