import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. Events

/// Base class for all settings-related events.
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

/// Event to toggle the application theme (Light/Dark).
class ToggleThemeEvent extends SettingsEvent {}

/// Event to toggle the application language.
class ToggleLanguageEvent extends SettingsEvent {}

// 2. State

/// Represents the current state of application settings.
class SettingsState extends Equatable {
  final bool isDark;
  final String languageCode;

  const SettingsState({required this.isDark, required this.languageCode});

  SettingsState copyWith({bool? isDark, String? languageCode}) {
    return SettingsState(
      isDark: isDark ?? this.isDark,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object> get props => [isDark, languageCode];
}

// 3. Bloc

/// Manages application settings and persists them using [SharedPreferences].
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences prefs;

  SettingsBloc({required this.prefs})
    : super(
        SettingsState(
          isDark: prefs.getBool('isDark') ?? false,
          languageCode: prefs.getString('languageCode') ?? 'en',
        ),
      ) {
    on<ToggleThemeEvent>((event, emit) async {
      final newMode = !state.isDark;
      await prefs.setBool('isDark', newMode);
      emit(state.copyWith(isDark: newMode));
    });

    on<ToggleLanguageEvent>((event, emit) async {
      final newLang = state.languageCode == 'en' ? 'ar' : 'en';
      await prefs.setString('languageCode', newLang);
      emit(state.copyWith(languageCode: newLang));
    });
  }
}