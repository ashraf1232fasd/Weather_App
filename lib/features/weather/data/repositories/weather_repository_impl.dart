import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_data_source.dart';
import '../datasources/weather_remote_data_source.dart';

/// Implementation of [WeatherRepository] that handles data retrieval strategy.
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  /// Fetches weather data based on network connectivity.
  ///
  /// Returns remote data if online (and caches it), otherwise returns cached data.
  Future<Either<Failure, Weather>> getWeatherByCity(
    String cityName,
    String languageCode,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteWeather = await remoteDataSource.getWeather(
          cityName,
          languageCode,
        );

        localDataSource.cacheWeather(remoteWeather);

        return Right(remoteWeather);
      } on ServerException {
        return const Left(ServerFailure('SERVER_FAILURE'));
      }
    } else {
      try {
        final localWeather = await localDataSource.getLastWeather();
        return Right(localWeather);
      } on CacheException {
        return const Left(CacheFailure('CACHE_FAILURE'));
      }
    }
  }

  @override
  /// Retrieves the last successfully cached weather data.
  Future<Either<Failure, Weather>> getLastCachedWeather() async {
    try {
      final localWeather = await localDataSource.getLastWeather();
      return Right(localWeather);
    } on CacheException {
      return const Left(CacheFailure('CACHE_FAILURE'));
    }
  }

  @override
  /// Retrieves the list of previously searched cities.
  Future<List<String>> getSearchHistory() async {
    try {
      return await localDataSource.getSearchHistory();
    } catch (e) {
      return [];
    }
  }

  @override
  /// Adds a city to the search history (silently ignores errors).
  Future<void> addCityToHistory(String cityName) async {
    try {
      await localDataSource.addCityToHistory(cityName);
    } catch (e) {
      // Fire and forget
    }
  }
}