import 'package:shamsi_date/shamsi_date.dart';

extension DateTimeExtensions on DateTime {
  // مقدار ورودی:
  // 2025-03-02

  // مقدار خروجی:
  // ۱۴۰۳/۱۲/۱۲ یکشنبه

  // شیوه انجام دادن:
  // final DateTime date = DateTime.parse(data.date!);
  // date.toJalaliFormatted()
  String toJalaliFormatted() {
    final jalaliDate = Jalali.fromDateTime(this);

    // دریافت نام روز هفته
    List<String> weekDays = [
      'یکشنبه',
      'دوشنبه',
      'سه‌شنبه',
      'چهارشنبه',
      'پنجشنبه',
      'جمعه',
      'شنبه',
    ];
    String weekDayName = weekDays[weekday % 7];

    return '$weekDayName ${jalaliDate.year}/${jalaliDate.month}/${jalaliDate.day}';
  }

  String toTimeFormatted() {
    // تبدیل ساعت و دقیقه به فرمت دلخواه
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  // مقدار ورودی:
  // 2025-03-15T10:14:30.244Z

  // مقدار خروجی:
  // اسفند 1403

  // شیوه انجام دادن:
  // final persianDate = DateTime.parse(data.date.toString()).toPersianMonthYear();
  String toPersianMonthYear() {
    final jalali = Jalali.fromDateTime(this);

    List<String> months = [
      "فروردین",
      "اردیبهشت",
      "خرداد",
      "تیر",
      "مرداد",
      "شهریور",
      "مهر",
      "آبان",
      "آذر",
      "دی",
      "بهمن",
      "اسفند"
    ];

    return "${months[jalali.month - 1]} ${jalali.year}";
  }

  // مقدار ورودی:
  // 2025-03-15T10:14:30.244Z

  // مقدار خروجی:
  // 1403/12/25

  // شیوه انجام دادن:
  // final paymentDate = DateTime.parse(data.paymentDate.toString()).toPersianNumericDate();
  String toPersianNumericDate() {
    final jalali = Jalali.fromDateTime(this);
    return "${jalali.year}/${jalali.month}/${jalali.day}";
  }
}
