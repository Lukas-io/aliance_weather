class ForecastModel {
  final List<ForecastDay> forecastDays;
  final List<HourlyForecast> hourlyForecasts;

  ForecastModel({required this.forecastDays, required this.hourlyForecasts});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final List<ForecastDay> days = [];
    final List<HourlyForecast> hourly = [];

    final forecastList = json['forecast']?['forecastday'] as List? ?? [];

    for (var day in forecastList) {
      days.add(ForecastDay.fromJson(day));

      // Extract hourly data from each day
      final hourlyList = day['hour'] as List? ?? [];
      for (var hour in hourlyList) {
        hourly.add(HourlyForecast.fromJson(hour));
      }
    }

    return ForecastModel(forecastDays: days, hourlyForecasts: hourly);
  }

  Map<String, dynamic> toJson() {
    return {
      'forecast': {
        'forecastday': forecastDays.map((day) => day.toJson()).toList(),
      },
    };
  }
}

class ForecastDay {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final ForecastCondition condition;
  final String icon;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.icon,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      maxTemp: (json['day']?['maxtemp_c'] ?? 0).toDouble(),
      minTemp: (json['day']?['mintemp_c'] ?? 0).toDouble(),
      condition: ForecastCondition.fromJson(json['day']?['condition'] ?? {}),
      icon: json['day']?['condition']?['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'day': {
        'maxtemp_c': maxTemp,
        'mintemp_c': minTemp,
        'condition': condition.toJson(),
      },
    };
  }
}

class ForecastCondition {
  final String text;
  final String icon;
  final int code;

  ForecastCondition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory ForecastCondition.fromJson(Map<String, dynamic> json) {
    return ForecastCondition(
      text: json['text'] ?? '',
      icon: json['icon'] ?? '',
      code: json['code'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'icon': icon, 'code': code};
  }
}

class HourlyForecast {
  final DateTime time;
  final double temp;
  final double humidity;
  final ForecastCondition condition;

  HourlyForecast({
    required this.time,
    required this.temp,
    required this.humidity,
    required this.condition,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.parse(json['time'] ?? DateTime.now().toIso8601String()),
      temp: (json['temp_c'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toDouble(),
      condition: ForecastCondition.fromJson(json['condition'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'temp_c': temp,
      'humidity': humidity,
      'condition': condition.toJson(),
    };
  }
}
