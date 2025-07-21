import 'package:easy_localization/easy_localization.dart';
import 'package:linchpin/core/translate/locale_keys.dart';

extension TimeConversion on int {
  String toHoursAndMinutes() {
    int hours = this ~/ 60; // تقسیم صحیح برای گرفتن ساعت
    int remainingMinutes = this % 60; // باقی‌مانده برای گرفتن دقیقه‌ها
    if (hours == 0 && remainingMinutes == 0) {
      return '-';
    } else {
      if (hours == 0 && remainingMinutes != 0) {
        return '$remainingMinutes ${LocaleKeys.minute.tr()}';
      } else if (remainingMinutes == 0 && hours != 0) {
        return '$hours ${LocaleKeys.hour.tr()}';
      } else {
        return '$hours ${LocaleKeys.hour.tr()} ${LocaleKeys.and.tr()} $remainingMinutes ${LocaleKeys.minute.tr()}';
      }
    }
  }

  // مقدار ورودی: 25
  // مقدار خروجی 25 دقیقه
  // مقدار ورودی: 65
  // مقدار خروجی: 1 ساعت و 5 دقیقه
  String get formattedTime {
    if (this >= 60) {
      int hours = this ~/ 60;
      int minutes = this % 60;
      if (minutes == 0) {
        return "$hours ساعت";
      }
      return "$hours ساعت و $minutes دقیقه";
    } else {
      return "$this دقیقه";
    }
  }
}
