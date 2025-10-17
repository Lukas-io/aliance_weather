import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:aliance_weather/controllers/weather_controller.dart';
import 'package:aliance_weather/controllers/location_controller.dart';
import 'package:aliance_weather/views/widgets/current_weather_widget.dart';
import 'package:aliance_weather/views/widgets/location_input_widget.dart';

import '../utils/weather_icon_mapper.dart';

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
                FocusManager.instance.primaryFocus?.unfocus();
                if (query.isNotEmpty) {
                  weatherController.searchWeather(query);
                }
              },
            ),
            const SizedBox(height: 50),

            // Display weather data if available
            Obx(() {
              if (weatherController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
                );
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
                final weather = weatherController.weatherData.value;
                return Column(
                  children: [
                    Text(
                      weather.location.name,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),

                    Row(),
                    // Weather icon
                    SvgPicture.asset(
                      WeatherIconMapper.getWeatherIconPath(
                        weather.current.condition.text,
                      ),
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${weather.current.temp.toStringAsFixed(0)}°C',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(letterSpacing: 1.7),
                    ),

                    Text(
                      weather.current.condition.text,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    const SizedBox(height: 20),
                  ],
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
