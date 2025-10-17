import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aliance_weather/models/weather_model.dart';
import 'package:aliance_weather/utils/weather_icon_mapper.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location name
            Text(
              weather.location.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),

            // Temperature and condition with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Temperature
                Text(
                  '${weather.current.temp.toStringAsFixed(0)}°C',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),

                // Weather condition with icon
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Weather icon
                    SvgPicture.asset(
                      WeatherIconMapper.getWeatherIconPath(
                        weather.current.condition.text,
                      ),
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      weather.current.condition.text,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Weather details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Humidity
                _WeatherDetailItem(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${weather.current.humidity}%',
                ),

                // Wind speed
                _WeatherDetailItem(
                  icon: Icons.air,
                  label: 'Wind',
                  value: '${weather.current.windSpeed} km/h',
                ),

                // Feels like
                _WeatherDetailItem(
                  icon: Icons.thermostat,
                  label: 'Feels like',
                  value: '${weather.current.feelsLike.toStringAsFixed(0)}°C',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherDetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 5),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
