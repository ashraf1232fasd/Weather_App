import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import '../bloc/weather_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/weather_info_display.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final weatherBloc = context.read<WeatherBloc>();
    if (weatherBloc.state is WeatherEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          final currentLocale = Localizations.localeOf(context).languageCode;
          weatherBloc.add(GetWeatherForCurrentLocation(currentLocale));
        }
      });
    }

    return Scaffold(
      body: BlocListener<SettingsBloc, SettingsState>(
        listenWhen: (previous, current) => previous.languageCode != current.languageCode,
        listener: (context, settingsState) {
          final weatherState = context.read<WeatherBloc>().state;
          if (weatherState is WeatherLoaded) {
            context.read<WeatherBloc>().add(
              GetWeatherForCity(weatherState.weather.cityName, settingsState.languageCode),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [const Color(0xFF1A2344), const Color(0xFF101010)]
                  : [const Color(0xFF4FA3F7), const Color(0xFF88CCF1)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, l10n),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        const CustomSearchBar(),
                        SizedBox(height: 20.h),
                        BlocBuilder<WeatherBloc, WeatherState>(
                          builder: (context, state) {
                            if (state is WeatherLoading) {
                              return const Center(child: CircularProgressIndicator(color: Colors.white));
                            } else if (state is WeatherLoaded) {
                              return WeatherInfoDisplay(weather: state.weather);
                            } else if (state is WeatherError) {
                              return _buildErrorState(context, state.message, l10n);
                            } else {
                              return _buildEmptyState(l10n);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String messageCode, AppLocalizations l10n) {
    bool isLocationError = messageCode == 'LOCATION_DISABLED' || messageCode == 'PERMISSION_DENIED';

    return Center(
      child: Column(
        children: [
          Text(
            messageCode == 'LOCATION_DISABLED' ? "الـ GPS مغلق" : l10n.unknownError,
            style: TextStyle(color: Colors.redAccent, fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          ElevatedButton.icon(
            onPressed: () async {
              if (messageCode == 'LOCATION_DISABLED') {
                await Geolocator.openLocationSettings();
              } else if (messageCode == 'PERMISSION_DENIED') {
                await Geolocator.openAppSettings();
              }

              if (!context.mounted) return;

              final currentLocale = Localizations.localeOf(context).languageCode;
              context.read<WeatherBloc>().add(GetWeatherForCurrentLocation(currentLocale));
            },
            icon: const Icon(Icons.location_on),
            label: Text(isLocationError ? "فتح الإعدادات للموافقة" : "إعادة المحاولة"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              foregroundColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoaded) {
                return IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    final currentLocale = Localizations.localeOf(context).languageCode;
                    context.read<WeatherBloc>().add(GetWeatherForCity(state.weather.cityName, currentLocale));
                  },
                );
              }
              return SizedBox(width: 48.w);
            },
          ),
          Text(l10n.appTitle, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white)),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Column(
      children: [
        SizedBox(height: 50.h),
        Icon(Icons.cloud_outlined, size: 100.sp, color: Colors.white.withValues(alpha: 0.5)),
        SizedBox(height: 20.h),
        Text(l10n.startSearching, style: TextStyle(fontSize: 20.sp, color: Colors.white70)),
      ],
    );
  }

  void _showSettingsDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLanguage = Localizations.localeOf(context).languageCode == 'ar' ? 'العربية' : 'English';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.settings,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            SizedBox(height: 10.h),
            
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
              tileColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.1),
              leading: Icon(Icons.language, color: Colors.blueAccent, size: 28.sp),
              title: Text(l10n.language, style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: Text(currentLanguage, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)), 
              onTap: () {
                context.read<SettingsBloc>().add(ToggleLanguageEvent());
                Navigator.pop(context);
              },
            ),
            
            SizedBox(height: 12.h),

            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
              tileColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.1),
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode, 
                color: isDark ? Colors.orangeAccent : Colors.amber, 
                size: 28.sp
              ),
              title: Text(l10n.theme, style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: Text(isDark ? 'Dark' : 'Light', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)), 
              onTap: () {
                context.read<SettingsBloc>().add(ToggleThemeEvent());
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
