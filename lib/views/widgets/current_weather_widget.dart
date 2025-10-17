import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aliance_weather/models/weather_model.dart';
import 'package:aliance_weather/utils/weather_icon_mapper.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(),
          // Weather icon
          Expanded(
            child: SvgPicture.asset(
              WeatherIconMapper.getWeatherIconPath(
                weather.current.condition.text,
              ),
              width: 150,
              height: 150,
            ),
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

          // Weather details
        ],
      ),
    );
  }
}
