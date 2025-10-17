import 'package:aliance_weather/views/widgets/forecast_widget.dart';
import 'package:aliance_weather/models/forecast_model.dart' as forecast;
import 'package:flutter/material.dart';

class DayForecastScreen extends StatelessWidget {
  final forecast.ForecastModel forecastData;

  const DayForecastScreen({super.key, required this.forecastData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5-Day Forecast'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ForecastWidget(forecast: forecastData),
        ),
      ),
    );
  }
}
