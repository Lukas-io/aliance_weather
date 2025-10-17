# Alliance Weather

A minimal weather app that displays real-time weather data and forecasts using WeatherAPI.

## Features

- Real-time weather data (temperature, humidity, wind speed)
- 5-day weather forecast
- Search weather by city
- Current location weather (with permission handling)
- Persistent storage of last searched location
- Default location: Lagos

## Screenshot
<img width="4800" height="3286" alt="slideshow" src="https://github.com/user-attachments/assets/bc8099b1-82cf-474f-8b67-c110da44b698" />

## Tech Stack

- Flutter
- GetX (state management)
- GetStorage (local storage)
- Geolocator (location services)
- HTTP (API calls)
- WeatherAPI.com (free tier)

## Getting Started

### Prerequisites
- Flutter SDK
- WeatherAPI.com free API key

### Setup

1. Clone the repository
2. Run `flutter pub get`
3. Add your WeatherAPI key to `lib/config/constants/api_constants.dart`
4. Run `flutter run`

## Project Structure

```
lib/
├── main.dart
├── config/
├── models/
├── controllers/
├── views/
├── services/
└── utils/
```

## Permissions

- **Android**: Location permission (coarse & fine)
- **iOS**: Location when in use

Permission requests are optional. App continues with default location if denied.
