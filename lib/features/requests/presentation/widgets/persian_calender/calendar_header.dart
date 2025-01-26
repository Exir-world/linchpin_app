import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/persian_calender/box_increase_decrease.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/persian_calender/persian_calendar.dart';
import 'package:shamsi_date/shamsi_date.dart';

/// ویجت CalendarHeader که مسئول نمایش هدر تقویم است.
/// این ویجت به کاربر این امکان را می‌دهد که ماه یا سال جاری را تغییر دهد و تاریخ‌ها را مشاهده کند.
class CalendarHeader extends StatefulWidget {
  /// نوع تقویم که می‌تواند 'روز'، 'ماه' یا 'سال' باشد.
  final String calendarType;

  const CalendarHeader({
    super.key,
    required this.calendarType, // نوع تقویم که مشخص می‌کند باید هدر مربوط به ماه، روز یا سال نمایش داده شود.
  });

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  /// تغییر ماه با توجه به پارامتر ورودی برای افزایش یا کاهش ماه.
  void _changeMonth(int increment) {
    int newMonth = PersianCalendar.currentDate.value!.month + increment;
    int newYear = PersianCalendar.currentDate.value!.year;

    // مدیریت تغییر سال و ماه در صورت عبور از محدوده ماه‌ها.
    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }

    // به‌روزرسانی تاریخ جدید با ماه و سال جدید.
    PersianCalendar.currentDate.value = Jalali(newYear, newMonth, 1);

    // اطلاع‌رسانی به سایر قسمت‌ها برای به‌روزرسانی تاریخ و روزهای ماه.
    PersianCalendar.persianDateNotifier.value =
        PersianCalendar.getPersianDate(PersianCalendar.currentDate.value!);
    PersianCalendar.daysOfMonthNotifier.value =
        PersianCalendar.getDaysOfMonth(PersianCalendar.currentDate.value!);

    // به‌روزرسانی تاریخ به فرمت اسلش.
    PersianCalendar.persianDateSlashNotifier.value =
        '${PersianCalendar.currentDate.value!.year}/${PersianCalendar.currentDate.value!.month}/${PersianCalendar.currentDate.value!.day}';

    // ریست کردن روز انتخاب‌شده.
    PersianCalendar.selectedDayNotifier.value = null;
  }

  /// تغییر سال با افزایش یا کاهش مقدار ورودی.
  void _changeYear(int increment) {
    // تغییر سال و بروزرسانی تاریخ.
    PersianCalendar.currentDate.value = Jalali(
        PersianCalendar.currentDate.value!.year + increment,
        PersianCalendar.currentDate.value!.month,
        1);

    PersianCalendar.persianDateNotifier.value =
        PersianCalendar.getPersianDate(PersianCalendar.currentDate.value!);
    PersianCalendar.daysOfMonthNotifier.value =
        PersianCalendar.getDaysOfMonth(PersianCalendar.currentDate.value!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44, // ارتفاع هدر تقویم.
      decoration: BoxDecoration(
        color: const Color(0xffF1F3F5), // رنگ پس‌زمینه هدر.
        borderRadius: BorderRadius.circular(6), // گوشه‌های گرد هدر.
      ),
      padding: const EdgeInsets.all(6), // فاصله داخلی هدر.
      margin: const EdgeInsets.only(bottom: 16), // فاصله هدر از سایر بخش‌ها.
      alignment: Alignment.center, // تراز کردن محتویات هدر در مرکز.
      child: widget.calendarType == 'day'
          // اگر تقویم نوع روز است.
          ? Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // فاصله‌ی برابر بین آیتم‌ها.
              children: [
                BoxIncreaseDecrease(
                  onTap: () => _changeMonth(1), // افزایش ماه.
                  icon: Icons.add, // آیکون افزودن.
                ),
                // نمایش تاریخ شمسی جاری.
                ValueListenableBuilder<String>(
                  valueListenable: PersianCalendar.persianDateNotifier,
                  builder: (context, persianDate, child) {
                    return GestureDetector(
                      onTap: () {
                        // تغییر نوع تقویم به ماه.
                        PersianCalendar.isTypeCalenderNotifier.value = 'month';
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: 150, // عرض ثابت برای تاریخ.
                        alignment: Alignment.center, // تراز کردن تاریخ در مرکز.
                        child: SmallMedium(
                          persianDate, // نمایش تاریخ شمسی.
                          textColorInLight: const Color(0xff861C8C), // رنگ متن.
                        ),
                      ),
                    );
                  },
                ),
                BoxIncreaseDecrease(
                  onTap: () => _changeMonth(-1), // کاهش ماه.
                  icon: Icons.remove, // آیکون حذف.
                ),
              ],
            )
          : widget.calendarType == 'month'
              // اگر تقویم نوع ماه است.
              ? ValueListenableBuilder<String>(
                  valueListenable: PersianCalendar.persianDateNotifier,
                  builder: (context, persianDate, child) {
                    RegExp regExp = RegExp(r'\d+'); // استخراج سال از تاریخ.
                    Match? match = regExp.firstMatch(persianDate);
                    String year = match != null ? match.group(0)! : '';

                    return GestureDetector(
                      onTap: () {
                        // تغییر نوع تقویم به سال.
                        PersianCalendar.isTypeCalenderNotifier.value = 'year';
                      },
                      child: Container(
                        width: double.infinity, // عرض کامل برای سال.
                        height: double.infinity, // ارتفاع کامل.
                        color: Colors.transparent,
                        alignment: Alignment.center, // تراز کردن سال در مرکز.
                        child: SmallMedium(
                          year, // نمایش سال.
                          textColorInLight: const Color(0xff861C8C), // رنگ متن.
                        ),
                      ),
                    );
                  },
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // فاصله‌ی برابر بین آیتم‌ها.
                  children: [
                    BoxIncreaseDecrease(
                      onTap: () => _changeYear(1), // افزایش سال.
                      icon: Icons.add, // آیکون افزودن.
                    ),
                    // نمایش سال جاری.
                    ValueListenableBuilder<String>(
                      valueListenable: PersianCalendar.persianDateNotifier,
                      builder: (context, persianDate, child) {
                        RegExp regExp = RegExp(r'\d+'); // استخراج سال.
                        Match? match = regExp.firstMatch(persianDate);
                        String year = match != null ? match.group(0)! : '';

                        return SmallMedium(
                          year, // نمایش سال.
                          textColorInLight: const Color(0xff861C8C), // رنگ متن.
                        );
                      },
                    ),
                    BoxIncreaseDecrease(
                      onTap: () => _changeYear(-1), // کاهش سال.
                      icon: Icons.remove, // آیکون حذف.
                    ),
                  ],
                ),
    );
  }
}
