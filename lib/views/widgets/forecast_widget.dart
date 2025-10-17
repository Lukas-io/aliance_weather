import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aliance_weather/models/forecast_model.dart';
import 'package:aliance_weather/utils/weather_icon_mapper.dart';

class ForecastWidget extends StatelessWidget {
  final ForecastModel forecast;

  const ForecastWidget({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    if (forecast.forecastDays.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('5-Day Forecast', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.forecastDays.length,
            itemBuilder: (context, index) {
              final day = forecast.forecastDays[index];
              return _ForecastDayItem(day: day);
            },
          ),
        ),
      ],
    );
  }
}

class _ForecastDayItem extends StatelessWidget {
  final ForecastDay day;

  const _ForecastDayItem({required this.day});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Day of week
            Text(
              _getDayOfWeek(day.date),
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 5),

            // Date
            Text(
              '${day.date.day}/${day.date.month}',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 10),

            // Weather icon
            SvgPicture.asset(
              WeatherIconMapper.getWeatherIconPath(day.condition.text),
              width: 30,
              height: 30,
            ),

            const SizedBox(height: 5),

            // Weather condition
            Text(
              day.condition.text,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // Temperature range
            Text(
              '${day.maxTemp.toStringAsFixed(0)}°',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              '${day.minTemp.toStringAsFixed(0)}°',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
