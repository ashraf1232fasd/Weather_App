import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/weather/data/datasources/weather_local_data_source.dart';
import 'features/weather/data/datasources/weather_remote_data_source.dart';
import 'features/weather/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/repositories/weather_repository.dart';
import 'features/weather/domain/usecases/get_weather_by_city.dart';
import 'features/weather/domain/usecases/get_cached_weather.dart';
import 'features/weather/presentation/bloc/weather_bloc.dart';

/// Global Service Locator instance.
final sl = GetIt.instance;

/// Initializes all application dependencies.
Future<void> init() async {
  //! Features - Weather

  // Bloc
  // Registered as a factory to ensure a new instance is created on each call.
  sl.registerFactory(
    () => WeatherBloc(getWeatherByCity: sl(), getCachedWeather: sl()),
  );

  sl.registerFactory(() => SettingsBloc(prefs: sl()));

  // Use cases
  // LazySingleton creates the instance only when it's first requested.
  sl.registerLazySingleton(() => GetWeatherByCity(sl()));
  sl.registerLazySingleton(() => GetCachedWeather(sl()));

  // Repository
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}