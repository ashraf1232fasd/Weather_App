// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق الطقس';

  @override
  String get searchHint => 'أدخل اسم المدينة';

  @override
  String get humidity => 'الرطوبة';

  @override
  String get windSpeed => 'الرياح';

  @override
  String get startSearching => 'ابدأ البحث الآن!';

  @override
  String get serverError => 'خطأ في الاتصال، حاول مرة أخرى';

  @override
  String get cachedData => 'بيانات محفوظة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get tempHigh => 'ع';

  @override
  String get tempLow => 'ص';

  @override
  String get unknownError => 'خطأ غير معروف';

  @override
  String get noCachedData => 'لا توجد بيانات محفوظة مسبقاً';
}
