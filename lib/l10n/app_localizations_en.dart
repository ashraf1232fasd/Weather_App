// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Weather App';

  @override
  String get searchHint => 'Enter city name';

  @override
  String get humidity => 'Humidity';

  @override
  String get windSpeed => 'Wind Speed';

  @override
  String get startSearching => 'Start searching now!';

  @override
  String get serverError => 'Server Error, please try again';

  @override
  String get cachedData => 'Cached Data';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get tempHigh => 'H';

  @override
  String get tempLow => 'L';

  @override
  String get unknownError => 'Unknown Error';

  @override
  String get noCachedData => 'No cached data found';
}
