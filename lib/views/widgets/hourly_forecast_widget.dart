import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aliance_weather/models/forecast_model.dart' as forecast;
import 'package:aliance_weather/utils/weather_icon_mapper.dart';
import 'package:aliance_weather/views/widgets/temperature_graph_painter.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<forecast.HourlyForecast> hourlyData;
  final Color graphColor;
  final double itemWidth;

  const HourlyForecastWidget({
    super.key,
    required this.hourlyData,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('24-Hour Forecast', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        // Graph view in horizontal scroll
        SizedBox(
          height: 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: hourlyData.length * 50.0,
              child: Stack(
                children: [
                  // Graph painter
                  CustomPaint(
                    painter: TemperatureGraphPainter(
                      hourlyData: hourlyData,
                      currentTimeIndex: currentTimeIndex,
                      lineColor: graphColor,
                      fillColor: graphColor,
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
      final y = 170 - ((hour.temp - minTemp) / (maxTemp - minTemp)) * 140;

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
