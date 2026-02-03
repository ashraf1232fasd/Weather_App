import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

/// Use case to retrieve the last known weather from local cache.
class GetCachedWeather implements UseCase<Weather, NoParams> {
  final WeatherRepository repository;

  GetCachedWeather(this.repository);

  @override
  /// Executes the logic to fetch cached data.
  Future<Either<Failure, Weather>> call(NoParams params) async {
    return await repository.getLastCachedWeather();
  }
}