part of 'weather_bloc.dart';

/// Abstract base class for all weather events.
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch weather for a specific city with localization.
class GetWeatherForCity extends WeatherEvent {
  final String cityName;
  final String languageCode;

  const GetWeatherForCity(this.cityName, this.languageCode);

  @override
  List<Object> get props => [cityName, languageCode];
}

/// Event to load the last cached weather data on startup.
class GetLastWeather extends WeatherEvent {}

///  Fetch weather based on device location
class GetWeatherForCurrentLocation extends WeatherEvent {
  final String languageCode;

  const GetWeatherForCurrentLocation(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}