import 'package:flutter/material.dart';
import 'package:linchpin_app/features/requests/widgets/persian_calender/calendar_header.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'persian_calendar.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';

class YearView extends StatefulWidget {
  const YearView({super.key});

  @override
  State<YearView> createState() => _YearViewState();
}

class _YearViewState extends State<YearView> {
  List<int> _getYearsForView() {
    int currentYear = PersianCalendar.currentDate.value!.year;
    return List.generate(
        12, (index) => currentYear + index); // فقط سال جاری و 11 سال بعد
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          CalendarHeader(calendarType: 'year'),
          ValueListenableBuilder(
            valueListenable: PersianCalendar.daysOfMonthNotifier,
            builder: (context, value, child) {
              return Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double spacing = 8.0; // فاصله بین آیتم‌ها
                    int crossAxisCount = 4; // تعداد ستون‌ها
                    double itemWidth = (constraints.maxWidth -
                            (crossAxisCount - 1) * spacing) /
                        crossAxisCount;
                    double itemHeight = itemWidth;
                    return Wrap(
                      spacing: spacing, // فاصله بین آیتم‌ها
                      runSpacing: spacing, // فاصله بین ردیف‌ها
                      direction: Axis.horizontal,
                      children: List.generate(12, (index) {
                        int year = _getYearsForView()[index];
                        return GestureDetector(
                          onTap: () {
                            PersianCalendar.persianDateSlashNotifier.value =
                                '$year/${PersianCalendar.currentDate.value!.month}/${PersianCalendar.currentDate.value!.day}';
                            PersianCalendar.currentDate.value = Jalali(year,
                                PersianCalendar.currentDate.value!.month, 1);
                            PersianCalendar.isTypeCalenderNotifier.value =
                                'month';
                            PersianCalendar.persianDateNotifier.value =
                                "${PersianCalendar.currentDate.value!.year} ${PersianCalendar.currentDate.value!.month}";
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: itemWidth,
                            height: itemHeight,
                            decoration: BoxDecoration(
                              color: Color(0xffF1F3F5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SmallMedium('$year'),
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
