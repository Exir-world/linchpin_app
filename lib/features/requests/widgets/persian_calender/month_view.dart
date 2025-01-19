import 'package:flutter/material.dart';
import 'package:linchpin_app/features/requests/widgets/persian_calender/calendar_header.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'persian_calendar.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';

class MonthView extends StatefulWidget {
  const MonthView({super.key});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  @override
  Widget build(BuildContext context) {
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
      height: 360,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // نمایش نام ماه جاری
          CalendarHeader(calendarType: 'month'),

          // نمایش روزهای ماه
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double spacing = 8.0; // فاصله بین آیتم‌ها
                int crossAxisCount = 3; // تعداد ستون‌ها
                double itemWidth =
                    (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                        crossAxisCount;
                double itemHeight = itemWidth / 1.8;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  direction: Axis.horizontal,
                  children: List.generate(months.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        PersianCalendar.currentDate.value = Jalali(
                            PersianCalendar.currentDate.value!.year,
                            index + 1,
                            1);
                        PersianCalendar.isTypeCalenderNotifier.value = 'day';
                        PersianCalendar.persianDateNotifier.value =
                            PersianCalendar.getPersianDate(
                                PersianCalendar.currentDate.value!);
                        PersianCalendar.daysOfMonthNotifier.value =
                            PersianCalendar.getDaysOfMonth(
                                PersianCalendar.currentDate.value!);
                        PersianCalendar.persianDateSlashNotifier.value =
                            '${PersianCalendar.currentDate.value!.year}/${PersianCalendar.currentDate.value!.month}/${PersianCalendar.currentDate.value!.day}';
                      },
                      child: Container(
                        width: itemWidth,
                        height: itemHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xffF1F3F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SmallMedium(months[index]),
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
