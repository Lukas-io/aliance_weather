import 'package:flutter/material.dart';
import 'package:aliance_weather/models/weather_model.dart';
import 'package:aliance_weather/views/widgets/sun_trajectory_painter.dart';

class SunTrajectoryWidget extends StatelessWidget {
  final WeatherModel weather;

  const SunTrajectoryWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    // Check if we have sunrise and sunset data
    if (weather.astro.sunrise.isEmpty || weather.astro.sunset.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDaytime = _isDaytime(
      weather.astro.sunrise,
      weather.astro.sunset,
      weather.lastUpdated,
    );

    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      child: CustomPaint(
        painter: SunTrajectoryPainter(
          sunriseTime: weather.astro.sunrise,
          sunsetTime: weather.astro.sunset,
          currentTime: weather.lastUpdated,
          isDaytime: isDaytime,
          trajectoryColor: Colors.grey.withValues(alpha: 0.5),
          passedTrajectoryColor: Colors.yellow,
          sunColor: isDaytime ? Colors.orange : Colors.lightBlue,
        ),
        size: const Size(double.infinity, 150),
      ),
    );
  }

  bool _isDaytime(String sunrise, String sunset, DateTime currentTime) {
    try {
      final sunriseParts = sunrise.split(':');
      final sunsetParts = sunset.split(':');

      if (sunriseParts.length < 2 || sunsetParts.length < 2) {
        return true;
      }

      final sunriseHour = int.parse(sunriseParts[0]);
      final sunriseMinute = int.parse(sunriseParts[1]);
      final sunsetHour = int.parse(sunsetParts[0]);
      final sunsetMinute = int.parse(sunsetParts[1]);

      final currentHour = currentTime.hour;
      final currentMinute = currentTime.minute;

      // Convert to minutes for comparison
      final sunriseMinutes = sunriseHour * 60 + sunriseMinute;
      final sunsetMinutes = sunsetHour * 60 + sunsetMinute;
      final currentMinutes = currentHour * 60 + currentMinute;

      return currentMinutes >= sunriseMinutes &&
          currentMinutes <= sunsetMinutes;
    } catch (e) {
      return true;
    }
  }
}
