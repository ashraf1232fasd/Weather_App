import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

/// Use case to retrieve weather data for a specific city.
class GetWeatherByCity implements UseCase<Weather, GetWeatherParams> {
  final WeatherRepository repository;

  GetWeatherByCity(this.repository);

  @override
  /// Executes the use case using the provided parameters.
  Future<Either<Failure, Weather>> call(GetWeatherParams params) async {
    return await repository.getWeatherByCity(
      params.cityName,
      params.languageCode,
    );
  }
}

/// Parameters required to fetch weather data (City & Language).
class GetWeatherParams {
  final String cityName;
  final String languageCode;

  GetWeatherParams({required this.cityName, required this.languageCode});
}