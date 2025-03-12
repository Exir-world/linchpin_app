import 'package:shamsi_date/shamsi_date.dart';

// مقدار ورودی:
// 2025-03-02

// مقدار خروجی:
// ۱۴۰۳/۱۲/۱۲ یکشنبه

// شیوه انجام دادن:
// final DateTime date = DateTime.parse(data.date!);
// date.toJalaliFormatted()
extension DateTimeExtensions on DateTime {
  String toJalaliFormatted() {
    final jalaliDate = Jalali.fromDateTime(this);

    // دریافت نام روز هفته
    List<String> weekDays = [
      'شنبه',
      'یکشنبه',
      'دوشنبه',
      'سه‌شنبه',
      'چهارشنبه',
      'پنجشنبه',
      'جمعه'
    ];
    String weekDayName = weekDays[weekday % 7];

    // برگرداندن رشته فرمت شده
    return '$weekDayName ${jalaliDate.year}/${jalaliDate.month}/${jalaliDate.day}';
  }

  String toTimeFormatted() {
    // تبدیل ساعت و دقیقه به فرمت دلخواه
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
