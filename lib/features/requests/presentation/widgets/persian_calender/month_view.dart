import 'package:flutter/material.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/features/requests/presentation/widgets/persian_calender/calendar_header.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'persian_calendar.dart';

/// ویجت MonthView برای نمایش ماه‌های سال به صورت گرید و انتخاب یک ماه خاص
class MonthView extends StatefulWidget {
  const MonthView({super.key});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  @override
  Widget build(BuildContext context) {
    // لیست ماه‌های سال به زبان فارسی
    const months = [
      'فروردین',
      'اردیبهشت',
      'خرداد',
      'تیر',
      'مرداد',
      'شهریور',
      'مهر',
      'آبان',
      'آذر',
      'دی',
      'بهمن',
      'اسفند'
    ];

    return Container(
      height: 360, // ارتفاع ویجت
      decoration: BoxDecoration(
        color: Colors.white, // رنگ پس‌زمینه
        borderRadius: BorderRadius.circular(8), // گوشه‌های گرد
      ),
      padding: const EdgeInsets.all(12), // فاصله داخلی
      child: Column(
        children: [
          // هدر تقویم که نوع ماه را نمایش می‌دهد
          CalendarHeader(calendarType: 'month'),

          // نمایش ماه‌ها در قالب گرید
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double spacing = 8.0; // فاصله بین ماه‌ها
                int crossAxisCount = 3; // تعداد ستون‌ها
                // محاسبه عرض و ارتفاع هر آیتم (ماه)
                double itemWidth =
                    (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                        crossAxisCount;
                double itemHeight = itemWidth / 1.8; // تنظیم نسبت ارتفاع به عرض

                return Wrap(
                  spacing: spacing, // فاصله افقی بین ماه‌ها
                  runSpacing: spacing, // فاصله عمودی بین ماه‌ها
                  direction: Axis.horizontal, // جهت نمایش ماه‌ها به صورت افقی
                  children: List.generate(months.length, (index) {
                    return GestureDetector(
                      // هنگام کلیک روی یک ماه، تاریخ روز اول آن ماه انتخاب می‌شود
                      onTap: () {
                        PersianCalendar.currentDate.value = Jalali(
                            PersianCalendar.currentDate.value!.year,
                            index + 1, // ماه انتخابی
                            1); // روز اول ماه
                        PersianCalendar.isTypeCalenderNotifier.value =
                            'day'; // تغییر نوع تقویم به روز
                        PersianCalendar.persianDateNotifier.value =
                            PersianCalendar.getPersianDate(PersianCalendar
                                .currentDate.value!); // به‌روزرسانی تاریخ فارسی
                        PersianCalendar.daysOfMonthNotifier.value =
                            PersianCalendar.getDaysOfMonth(PersianCalendar
                                .currentDate.value!); // به‌روزرسانی روزهای ماه
                        PersianCalendar.persianDateSlashNotifier.value =
                            '${PersianCalendar.currentDate.value!.year}/${PersianCalendar.currentDate.value!.month}/${PersianCalendar.currentDate.value!.day}'; // به‌روزرسانی تاریخ با فرمت اسلش
                      },
                      child: Container(
                        width: itemWidth, // عرض هر ماه
                        height: itemHeight, // ارتفاع هر ماه
                        alignment:
                            Alignment.center, // تراز کردن نام ماه در مرکز
                        decoration: BoxDecoration(
                          color: Color(0xffF1F3F5), // رنگ پس‌زمینه هر ماه
                          borderRadius:
                              BorderRadius.circular(8), // گوشه‌های گرد
                        ),
                        child: SmallMedium(months[index]), // نمایش نام ماه
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
