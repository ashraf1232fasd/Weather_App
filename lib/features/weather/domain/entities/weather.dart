import 'package:equatable/equatable.dart';

/// Domain entity representing essential weather information.
class Weather extends Equatable {
  final String cityName;
  final String description;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;

  const Weather({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
  });

  @override
  List<Object?> get props => [
        cityName,
        description,
        temperature,
        tempMin,
        tempMax,
        humidity,
        windSpeed,
      ];
}