class WeatherModel {
  final Location location;
  final Current current;
  final DateTime lastUpdated;

  WeatherModel({
    required this.location,
    required this.current,
    required this.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: Location.fromJson(json['location'] ?? {}),
      current: Current.fromJson(json['current'] ?? {}),
      lastUpdated: DateTime.parse(
        json['current']['last_updated'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'current': current.toJson(),
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

class Location {
  final String name;
  final double lat;
  final double lon;

  Location({required this.name, required this.lat, required this.lon});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lon: (json['lon'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'lat': lat, 'lon': lon};
  }
}

class Current {
  final double temp;
  final WeatherCondition condition;
  final int humidity;
  final double windSpeed;
  final String icon;
  final double feelsLike;

  Current({
    required this.temp,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.feelsLike,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      temp: (json['temp_c'] ?? 0).toDouble(),
      condition: WeatherCondition.fromJson(json['condition'] ?? {}),
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['wind_kph'] ?? 0).toDouble(),
      icon: json['condition']?['icon'] ?? '',
      feelsLike: (json['feelslike_c'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp_c': temp,
      'condition': condition.toJson(),
      'humidity': humidity,
      'wind_kph': windSpeed,
      'feelslike_c': feelsLike,
    };
  }
}

class WeatherCondition {
  final String text;
  final String icon;
  final int code;

  WeatherCondition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      text: json['text'] ?? '',
      icon: json['icon'] ?? '',
      code: json['code'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'icon': icon, 'code': code};
  }
}
