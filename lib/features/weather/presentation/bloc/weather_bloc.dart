import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/usecases/usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_cached_weather.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_weather_by_city.dart';

part 'weather_event.dart';
part 'weather_state.dart';

/// Manages the state of the weather view (Loading, Loaded, Error).
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherByCity getWeatherByCity;
  final GetCachedWeather getCachedWeather;

  WeatherBloc({required this.getWeatherByCity, required this.getCachedWeather})
    : super(WeatherEmpty()) {
    
    /// Handler for fetching weather by city name.
    on<GetWeatherForCity>((event, emit) async {
      emit(WeatherLoading());

      final failureOrWeather = await getWeatherByCity(
        GetWeatherParams(
          cityName: event.cityName,
          languageCode: event.languageCode,
        ),
      );

      failureOrWeather.fold(
        (failure) => emit(WeatherError(_mapFailureToKey(failure))),
        (weather) => emit(WeatherLoaded(weather)),
      );
    });

    /// Handler for retrieving the last cached weather data.
    on<GetLastWeather>((event, emit) async {
      emit(WeatherLoading());
      final result = await getCachedWeather(NoParams());
      result.fold(
        (failure) => emit(WeatherEmpty()),
        (weather) => emit(WeatherLoaded(weather)),
      );
    });
  }

  /// Maps domain failures to specific error keys for localization.
  String _mapFailureToKey(Failure failure) {
    if (failure is ServerFailure) return 'SERVER_FAILURE';
    if (failure is CacheFailure) return 'CACHE_FAILURE';
    return 'UNKNOWN_ERROR';
  }
}