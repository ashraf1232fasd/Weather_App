import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import '../bloc/weather_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/weather_info_display.dart';

/// The main screen displaying weather information and search functionality.
class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      /// Listens to [SettingsBloc] to automatically refresh weather data
      /// when the language changes (forcing a re-fetch with new lang code).
      body: BlocListener<SettingsBloc, SettingsState>(
        listenWhen: (previous, current) =>
            previous.languageCode != current.languageCode,
        listener: (context, settingsState) {
          final weatherState = context.read<WeatherBloc>().state;
          if (weatherState is WeatherLoaded) {
            context.read<WeatherBloc>().add(
                  GetWeatherForCity(
                    weatherState.weather.cityName,
                    settingsState.languageCode,
                  ),
                );
          }
        },
        child: Container(
          // Dynamic background gradient based on the current theme (Dark/Light).
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
                        
                        // Handles UI states: Loading, Loaded, Error, Empty.
                        BlocBuilder<WeatherBloc, WeatherState>(
                          builder: (context, state) {
                            if (state is WeatherLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            } else if (state is WeatherLoaded) {
                              return WeatherInfoDisplay(weather: state.weather);
                            } else if (state is WeatherError) {
                              String errorMessage;
                              switch (state.message) {
                                case 'SERVER_FAILURE':
                                  errorMessage = l10n.serverError;
                                  break;
                                case 'CACHE_FAILURE':
                                  errorMessage = l10n.noCachedData;
                                  break;
                                default:
                                  errorMessage = l10n.unknownError;
                              }
                              return Center(
                                child: Text(
                                  errorMessage,
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
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

  /// Builds the custom app bar with refresh and settings actions.
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
                    final currentLocale = Localizations.localeOf(
                      context,
                    ).languageCode;
                    context.read<WeatherBloc>().add(
                          GetWeatherForCity(
                              state.weather.cityName, currentLocale),
                        );
                  },
                );
              }
              return SizedBox(width: 48.w);
            },
          ),
          Text(
            l10n.appTitle,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
    );
  }

  /// UI to display when no city has been searched yet.
  Widget _buildEmptyState(AppLocalizations l10n) {
    return Column(
      children: [
        SizedBox(height: 50.h),
        Icon(
          Icons.cloud_outlined,
          size: 100.sp,
          color: Colors.white.withOpacity(0.5),
        ),
        SizedBox(height: 20.h),
        Text(
          l10n.startSearching,
          style: TextStyle(fontSize: 20.sp, color: Colors.white70),
        ),
      ],
    );
  }

  /// Displays a bottom sheet to toggle Language and Theme.
  void _showSettingsDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(20.w),
        height: 200.h,
        child: Column(
          children: [
            Text(
              l10n.settings,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.language),
              trailing: const Icon(Icons.swap_horiz),
              onTap: () {
                context.read<SettingsBloc>().add(ToggleLanguageEvent());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(l10n.theme),
              trailing: const Icon(Icons.toggle_on),
              onTap: () {
                context.read<SettingsBloc>().add(ToggleThemeEvent());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}