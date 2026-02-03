import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetWeatherByLocation {
  final WeatherRepository repository;

  GetWeatherByLocation(this.repository);

  /// Executes the use case to get weather by coordinates.
  Future<Either<Failure, Weather>> call(double lat, double lon, String languageCode) async {
    return await repository.getWeatherByLocation(lat, lon, languageCode);
  }
}