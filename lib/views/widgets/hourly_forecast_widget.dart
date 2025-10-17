import 'package:aliance_weather/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aliance_weather/models/forecast_model.dart' as forecast;
import 'package:aliance_weather/utils/weather_icon_mapper.dart';
import 'package:aliance_weather/views/widgets/temperature_graph_painter.dart';

import '../../models/weather_model.dart';
import '../day_forecast_screen.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<forecast.HourlyForecast> hourlyData;
  final WeatherModel weather;
  final forecast.ForecastModel forecastData;

  final Color graphColor;
  final double itemWidth;

  const HourlyForecastWidget({
    super.key,
    required this.hourlyData,
    required this.forecastData,
    required this.weather,
    this.graphColor = Colors.blue,
    this.itemWidth = 50,
  });

  @override
  Widget build(BuildContext context) {
    if (hourlyData.isEmpty) {
      return const SizedBox.shrink();
    }

    // Find current time index
    final now = DateTime.now();
    int currentTimeIndex = 0;
    for (int i = 0; i < hourlyData.length; i++) {
      if (hourlyData[i].time.isAfter(now)) {
        currentTimeIndex = i > 0 ? i - 1 : 0;
        break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Today',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DayForecastScreen(forecastData: forecastData),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Text(
                                'View 5-day forecast',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        value:
                            '${weather.current.feelsLike.toStringAsFixed(0)}°C',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Graph view in horizontal scroll
            SizedBox(
              height: 200,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
                physics: ClampingScrollPhysics(),
                child: SizedBox(
                  width: hourlyData.length * 50.0,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Graph painter
                      CustomPaint(
                        painter: TemperatureGraphPainter(
                          hourlyData: hourlyData,
                          currentTimeIndex: currentTimeIndex,
                          lineColor: Colors.black87,
                          fillColor: WeatherColors.card,
                          currentTimeIndicatorColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        size: Size(hourlyData.length * 50.0, 200),
                      ),
                      // Overlay SVG icons on chart points
                      ..._buildIconOverlay(hourlyData, currentTimeIndex),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIconOverlay(
    List<forecast.HourlyForecast> hourlyData,
    int currentTimeIndex,
  ) {
    final widgets = <Widget>[];
    final double widthPerHour = 50.0;

    // Find min and max temperatures for scaling
    double minTemp = hourlyData.first.temp;
    double maxTemp = hourlyData.first.temp;

    for (final hour in hourlyData) {
      if (hour.temp < minTemp) minTemp = hour.temp;
      if (hour.temp > maxTemp) maxTemp = hour.temp;
    }

    // Add some padding to the range
    final tempRange = (maxTemp - minTemp).abs();
    minTemp -= tempRange * 0.1;
    maxTemp += tempRange * 0.1;

    if (tempRange == 0) {
      minTemp -= 1;
      maxTemp += 1;
    }

    for (int i = 0; i < hourlyData.length; i++) {
      final hour = hourlyData[i];
      final x = i * widthPerHour;
      // Calculate Y position to match the painter
      final y = 220 - ((hour.temp - minTemp) / (maxTemp - minTemp)) * 140;

      widgets.add(
        Positioned(
          left: x - 12,
          top: y - 32,
          child: SvgPicture.asset(
            WeatherIconMapper.getWeatherIconPath(hour.condition.text),
            width: 24,
            height: 24,
          ),
        ),
      );
    }

    return widgets;
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
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Text(value, style: TextStyle(fontSize: 24, color: Colors.black87)),
      ],
    );
  }
}
