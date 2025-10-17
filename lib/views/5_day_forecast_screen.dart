import 'package:aliance_weather/views/widgets/forecast_widget.dart';
import 'package:flutter/material.dart';

class DayForecastScreen extends StatelessWidget {
  const DayForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Forecast widget
            Expanded(
              child: ForecastWidget(
                forecast: weatherController.forecastData.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
