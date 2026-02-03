import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart'; 
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/usecases/usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_cached_weather.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_weather_by_city.dart';
import '../../domain/usecases/get_weather_by_location.dart'; 

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherByCity getWeatherByCity;
  final GetCachedWeather getCachedWeather;
  final GetWeatherByLocation getWeatherByLocation; 

  WeatherBloc({
    required this.getWeatherByCity,
    required this.getCachedWeather,
    required this.getWeatherByLocation, 
  }) : super(WeatherEmpty()) {

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

    on<GetLastWeather>((event, emit) async {
      emit(WeatherLoading());
      final result = await getCachedWeather(NoParams());
      result.fold(
        (failure) => emit(WeatherEmpty()),
        (weather) => emit(WeatherLoaded(weather)),
      );
    });

    on<GetWeatherForCurrentLocation>((event, emit) async {
      emit(WeatherLoading());
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          emit(const WeatherError('LOCATION_DISABLED'));
          return;
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            emit(const WeatherError('PERMISSION_DENIED'));
            return;
          }
        }
        
        if (permission == LocationPermission.deniedForever) {
          emit(const WeatherError('PERMISSION_DENIED_FOREVER'));
          return;
        }

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final result = await getWeatherByLocation(
          position.latitude,
          position.longitude,
          event.languageCode,
        );

        result.fold(
          (failure) => emit(WeatherError(_mapFailureToKey(failure))),
          (weather) => emit(WeatherLoaded(weather)),
        );
      } catch (e) {
        emit(const WeatherError('UNKNOWN_ERROR'));
      }
    });
  }

  String _mapFailureToKey(Failure failure) {
    if (failure is ServerFailure) return 'SERVER_FAILURE';
    if (failure is CacheFailure) return 'CACHE_FAILURE';
    return 'UNKNOWN_ERROR';
  }
}
