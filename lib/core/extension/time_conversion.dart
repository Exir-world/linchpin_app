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
}
