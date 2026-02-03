import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather.dart';

/// Contract for the repository handling weather data operations.
abstract class WeatherRepository {
  /// Fetches weather data for a [cityName] with the specified [languageCode].
  Future<Either<Failure, Weather>> getWeatherByCity(
    String cityName,
    String languageCode,
  );

  ///  Fetches weather data using coordinates [lat] & [lon].
  Future<Either<Failure, Weather>> getWeatherByLocation(
    double lat,
    double lon,
    String languageCode,
  );

  /// Retrieves the last successfully cached weather data.
  Future<Either<Failure, Weather>> getLastCachedWeather();

  /// Gets the list of recently searched cities.
  Future<List<String>> getSearchHistory();

  /// Adds a city to the local search history.
  Future<void> addCityToHistory(String cityName);
}