import 'package:aliance_weather/core/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aliance_weather/controllers/weather_controller.dart';
import 'package:aliance_weather/controllers/location_controller.dart';
import 'package:aliance_weather/views/search_screen.dart';
import 'package:aliance_weather/views/widgets/current_weather_widget.dart';
import 'package:aliance_weather/views/widgets/forecast_widget.dart';
import 'package:aliance_weather/views/widgets/hourly_forecast_widget.dart';
import 'package:aliance_weather/views/widgets/sun_trajectory_widget.dart';
import 'package:intl/intl.dart';

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
    weatherController = Get.put(WeatherController());
    locationController = Get.put(LocationController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (weatherController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
          );
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
        final now = DateTime.now();
        final formatted = DateFormat('EEEE, hh:mma').format(now);
        // onRefresh: () async {
        //   // Refresh weather data
        //   final position = await locationController.getCurrentLocation();
        //   if (position != null) {
        //     await weatherController.fetchWeatherByLocation(
        //       position.latitude,
        //       position.longitude,
        //     );
        //   }
        // },
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            weatherController.weatherData.value.location.name,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  height: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          ),
                          Text(
                            formatted,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.search, size: 28),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Current weather widget
              Expanded(
                child: CurrentWeatherWidget(
                  weather: weatherController.weatherData.value,
                ),
              ),
              // Use current location button

              // // Sun trajectory widget
              // SunTrajectoryWidget(
              //   weather: weatherController.weatherData.value,
              // ),
              // const SizedBox(height: 30),

              // Hourly forecast widget
              HourlyForecastWidget(
                hourlyData: weatherController.getNext24Hours(),
                graphColor: Theme.of(context).colorScheme.primary,
                forecastData: weatherController.forecastData.value,
                weather: weatherController.weatherData.value,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: AlignmentGeometry.center,
                  child: InkWell(
                    onTap: () async {
                      final position = await locationController
                          .getCurrentLocation();
                      if (position != null) {
                        await weatherController.fetchWeatherByLocation(
                          position.latitude,
                          position.longitude,
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          Text(
                            'Use Current Location',
                            style: TextStyle(
                              fontSize: 16,
                              color: WeatherColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(Icons.my_location, color: WeatherColors.primary),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // // Error message for location
              // Obx(() {
              //   if (locationController.errorMessage.value.isNotEmpty) {
              //     return Padding(
              //       padding: const EdgeInsets.only(top: 10),
              //       child: Text(
              //         locationController.errorMessage.value,
              //         style: TextStyle(
              //           color: Theme.of(context).colorScheme.error,
              //           fontSize: 14,
              //         ),
              //         textAlign: TextAlign.center,
              //       ),
              //     );
              //   }
              //   return const SizedBox.shrink();
              // }),
            ],
          ),
        );
      }),
    );
  }
}
