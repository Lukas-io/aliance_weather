class WeatherIconMapper {
  // Map weather condition text to SVG file names
  static String getWeatherIcon(String conditionText) {
    final text = conditionText.toLowerCase();

    // Clear conditions
    if (text.contains('sunny') || text.contains('clear')) {
      return 'clear_day.svg';
    }

    // Cloudy conditions
    if (text.contains('cloudy') || text.contains('overcast')) {
      if (text.contains('partly') || text.contains('partially')) {
        return 'partly_cloudy_day.svg';
      }
      return 'cloudy.svg';
    }

    // Rain conditions
    if (text.contains('rain') ||
        text.contains('drizzle') ||
        text.contains('shower')) {
      if (text.contains('light')) {
        return 'rain_with_cloudy_light.svg';
      } else if (text.contains('heavy') || text.contains('torrential')) {
        return 'heavy_rain.svg';
      }
      return 'rain_with_cloudy_dark.svg';
    }

    // Snow conditions
    if (text.contains('snow') ||
        text.contains('blizzard') ||
        text.contains('flurries')) {
      if (text.contains('light')) {
        return 'snow_with_cloudy_light.svg';
      } else if (text.contains('heavy')) {
        return 'heavy_snow.svg';
      }
      return 'snow_with_cloudy_dark.svg';
    }

    // Thunderstorm conditions
    if (text.contains('thunder') || text.contains('storm')) {
      return 'strong_thunderstorms.svg';
    }

    // Mist/Fog conditions
    if (text.contains('mist') ||
        text.contains('fog') ||
        text.contains('haze')) {
      return 'haze_fog_dust_smoke.svg';
    }

    // Default icon
    return 'clear_day.svg';
  }

  // Get the full path for the weather icon
  static String getWeatherIconPath(String conditionText) {
    return 'assets/svg/weather/${getWeatherIcon(conditionText)}';
  }
}
