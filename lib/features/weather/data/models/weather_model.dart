import '../../domain/entities/weather.dart';

/// Data model representing weather details, extending the domain entity.
class WeatherModel extends Weather {
  const WeatherModel({
    required super.cityName,
    required super.description,
    required super.temperature,
    required super.tempMin,
    required super.tempMax,
    required super.humidity,
    required super.windSpeed,
  });

  /// Creates a [WeatherModel] from JSON map.
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      description: json['weather'][0]['description'],
      temperature: (json['main']['temp'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }

  /// Converts the model to JSON map for caching.
  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'weather': [
        {'description': description},
      ],
      'main': {
        'temp': temperature,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'humidity': humidity,
      },
      'wind': {'speed': windSpeed},
    };
  }
}