import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/weather_model.dart';

/// Interface for local data storage handling weather and search history.
abstract class WeatherLocalDataSource {
  /// Retrieves the last cached weather data.
  ///
  /// Throws [CacheException] if no data is found.
  Future<WeatherModel> getLastWeather();

  /// Caches the provided weather data locally.
  Future<void> cacheWeather(WeatherModel weatherToCache);

  /// Retrieves the list of previously searched cities.
  Future<List<String>> getSearchHistory();

  /// Adds a city to the search history.
  Future<void> addCityToHistory(String cityName);
}

const String cachedWeatherKey = 'CACHED_WEATHER';
const String searchHistoryKey = 'SEARCH_HISTORY';

/// Implementation of [WeatherLocalDataSource] using [SharedPreferences].
class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<WeatherModel> getLastWeather() {
    final jsonString = sharedPreferences.getString(cachedWeatherKey);
    if (jsonString != null) {
      return Future.value(WeatherModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheWeather(WeatherModel weatherToCache) {
    return sharedPreferences.setString(
      cachedWeatherKey,
      json.encode(weatherToCache.toJson()),
    );
  }

  @override
  Future<List<String>> getSearchHistory() async {
    return sharedPreferences.getStringList(searchHistoryKey) ?? [];
  }

  @override
  Future<void> addCityToHistory(String cityName) async {
    List<String> history =
        sharedPreferences.getStringList(searchHistoryKey) ?? [];
    history.remove(cityName);
    history.insert(0, cityName);
    if (history.length > 10) {
      history = history.sublist(0, 10);
    }
    await sharedPreferences.setStringList(searchHistoryKey, history);
  }
}