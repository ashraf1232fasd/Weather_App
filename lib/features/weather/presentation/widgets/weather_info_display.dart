import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import '../../domain/entities/weather.dart';

/// Reusable widget to display detailed weather information.
///
/// Features a "Glassmorphism" design card for humidity and wind details,
/// and responsive typography for temperature and city name.
class WeatherInfoDisplay extends StatelessWidget {
  final Weather weather;

  const WeatherInfoDisplay({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          // City Name with Shadow
          Text(
            weather.cityName,
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black26,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          // Current Temperature (Large & Thin font)
          Text(
            '${weather.temperature.toStringAsFixed(0)}°',
            style: TextStyle(
              fontSize: 90.sp,
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
          ),

          // Weather Condition (e.g., Clear Sky)
          Text(
            weather.description.toUpperCase(),
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white70,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w500,
            ),
          ),

          // High / Low Temperature with Localization
          Text(
            '${l10n.tempHigh}: ${weather.tempMax.toStringAsFixed(0)}°  ${l10n.tempLow}: ${weather.tempMin.toStringAsFixed(0)}°',
            style: TextStyle(fontSize: 16.sp, color: Colors.white70),
          ),

          SizedBox(height: 40.h),

          // Glassmorphism Detail Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  Icons.water_drop_outlined,
                  '${weather.humidity}%',
                  l10n.humidity,
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: Colors.white30,
                ), // Vertical Divider
                _buildDetailItem(
                  Icons.air_outlined,
                  '${weather.windSpeed} m/s',
                  l10n.windSpeed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build a vertical column for a single weather detail.
  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28.sp),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: Colors.white70),
        ),
      ],
    );
  }
}