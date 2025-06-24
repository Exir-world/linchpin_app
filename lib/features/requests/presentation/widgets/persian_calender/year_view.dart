import 'package:flutter/material.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/persian_calender/calendar_header.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/persian_calender/persian_calendar.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';

/// ویجت YearView برای نمایش سال‌های قابل انتخاب در تقویم
class YearView extends StatefulWidget {
  const YearView({super.key});

  @override
  State<YearView> createState() => _YearViewState();
}

class _YearViewState extends State<YearView> {
  // این متد برای تولید یک لیست از سال‌ها برای نمایش استفاده می‌شود
  // فقط سال جاری و 11 سال بعد از آن را شامل می‌شود
  List<int> _getYearsForView() {
    int currentYear = PersianCalendar.currentDate.value!.year;
    return List.generate(
      12,
      (index) => currentYear + index,
    ); // سال جاری و 11 سال بعد
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350, // ارتفاع ویجت
      decoration: BoxDecoration(
        color: Colors.white, // رنگ پس‌زمینه
        borderRadius: BorderRadius.circular(8), // گوشه‌های گرد
      ),
      padding: const EdgeInsets.all(12), // فاصله داخلی
      child: Column(
        children: [
          // هدر تقویم که نوع سال را نمایش می‌دهد
          const CalendarHeader(calendarType: 'year'),

          // استفاده از ValueListenableBuilder برای واکنش به تغییرات در روزهای ماه
          ValueListenableBuilder(
            valueListenable: PersianCalendar.daysOfMonthNotifier,
            builder: (context, value, child) {
              return Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double spacing = 8.0; // فاصله بین سال‌ها
                    int crossAxisCount = 4; // تعداد ستون‌ها
                    // محاسبه عرض و ارتفاع هر آیتم (سال)
                    double itemWidth = (constraints.maxWidth -
                            (crossAxisCount - 1) * spacing) /
                        crossAxisCount;
                    double itemHeight = itemWidth; // نسبت ارتفاع به عرض

                    return Wrap(
                      spacing: spacing, // فاصله افقی بین سال‌ها
                      runSpacing: spacing, // فاصله عمودی بین سال‌ها
                      direction: Axis.horizontal, // جهت افقی
                      children: List.generate(12, (index) {
                        // دریافت سال برای نمایش
                        int year = _getYearsForView()[index];
                        return GestureDetector(
                          // هنگام کلیک روی یک سال، تاریخ انتخابی به آن سال تغییر می‌کند
                          onTap: () {
                            // بروزرسانی تاریخ با استفاده از سال انتخابی
                            PersianCalendar.persianDateSlashNotifier.value =
                                '$year/${PersianCalendar.currentDate.value!.month}/${PersianCalendar.currentDate.value!.day}';
                            PersianCalendar.currentDate.value = Jalali(
                              year,
                              PersianCalendar.currentDate.value!.month,
                              1,
                            );
                            PersianCalendar.isTypeCalenderNotifier.value =
                                'month'; // تغییر به حالت ماه
                            PersianCalendar.persianDateNotifier.value =
                                "${PersianCalendar.currentDate.value!.year} ${PersianCalendar.currentDate.value!.month}";
                          },
                          child: Container(
                            alignment:
                                Alignment.center, // تراز کردن سال در مرکز
                            width: itemWidth, // عرض هر سال
                            height: itemHeight, // ارتفاع هر سال
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xffF1F3F5), // رنگ پس‌زمینه هر سال
                              borderRadius:
                                  BorderRadius.circular(8), // گوشه‌های گرد
                            ),
                            child: SmallMedium('$year'), // نمایش سال
                          ),
                        );
                      }),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
