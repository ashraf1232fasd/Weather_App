part of 'weather_bloc.dart';

/// Abstract base class for all weather states.
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

/// Initial state when no action has been taken.
class WeatherEmpty extends WeatherState {}

/// State indicating that data is currently being fetched.
class WeatherLoading extends WeatherState {}

/// State indicating successful data retrieval.
class WeatherLoaded extends WeatherState {
  final Weather weather;

  const WeatherLoaded(this.weather);

  @override
  List<Object> get props => [weather];
}

/// State indicating that an error occurred.
class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}