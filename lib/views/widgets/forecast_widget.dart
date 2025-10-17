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
        Text(
          '5-Day Forecast',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        // Make it a list instead of horizontal scroll
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: forecast.forecastDays.length,
          itemBuilder: (context, index) {
            final day = forecast.forecastDays[index];
            return _ForecastDayItem(day: day);
          },
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Date and day
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDayOfWeek(day.date),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${day.date.day}/${day.date.month}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            
            // Weather icon
            SvgPicture.asset(
              WeatherIconMapper.getWeatherIconPath(day.condition.text),
              width: 40,
              height: 40,
            ),
            
            // Weather condition
            Expanded(
              child: Text(
                day.condition.text,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Temperature range
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
          ],
        ),
      ),
    );
  }

  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}