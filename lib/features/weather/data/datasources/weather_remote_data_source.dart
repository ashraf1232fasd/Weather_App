import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/error/exceptions.dart';
import '../models/weather_model.dart';

/// Interface for fetching weather data from a remote API.
abstract class WeatherRemoteDataSource {
  /// Calls the API to get weather for [cityName] in [languageCode].
  ///
  /// Throws [ServerException] on non-200 response or network error.
  Future<WeatherModel> getWeather(String cityName, String languageCode);

  /// Calls the API to get weather using coordinates [lat] & [lon].
  Future<WeatherModel> getWeatherByLocation(double lat, double lon, String languageCode);
}

/// Implementation of [WeatherRemoteDataSource] using [Dio].
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  WeatherRemoteDataSourceImpl({required this.dio});

  @override
  Future<WeatherModel> getWeather(String cityName, String languageCode) async {
    try {
      final apiKey = dotenv.env['API_KEY'];

      final response = await dio.get(
        _baseUrl,
        queryParameters: {
          'q': cityName,
          'appid': apiKey,
          'units': 'metric',
          'lang': languageCode,
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  ///  Implementation of the location-based fetch
  @override
  Future<WeatherModel> getWeatherByLocation(double lat, double lon, String languageCode) async {
    try {
      final apiKey = dotenv.env['API_KEY'];

      final response = await dio.get(
        _baseUrl,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
          'lang': languageCode,
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}