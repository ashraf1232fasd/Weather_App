import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weather_app/injection_container.dart' as di;
import 'package:weather_app/l10n/app_localizations.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/weather/presentation/bloc/weather_bloc.dart';
import 'features/weather/presentation/pages/weather_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await di.init();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            // Injecting WeatherBloc and triggering initial data fetch.
            BlocProvider(
              create: (_) => di.sl<WeatherBloc>()..add(GetLastWeather()),
            ),
            // Injecting SettingsBloc for theme and language management.
            BlocProvider(create: (_) => di.sl<SettingsBloc>()),
          ],
          // Rebuilds MaterialApp whenever settings (Theme/Language) change.
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'Weather App',
                debugShowCheckedModeBanner: false,

                // 1. Dynamic Theme Mode
                themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),

                // 2. Dynamic Locale
                locale: Locale(state.languageCode),

                // Localization Delegates
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'), // English
                  Locale('ar'), // Arabic
                ],

                home: const WeatherPage(),
              );
            },
          ),
        );
      },
    );
  }
}