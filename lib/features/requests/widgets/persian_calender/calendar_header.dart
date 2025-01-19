import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/requests/widgets/persian_calender/box_increase_decrease.dart';
import 'package:linchpin_app/features/requests/widgets/persian_calender/persian_calendar.dart';
import 'package:shamsi_date/shamsi_date.dart';

class CalendarHeader extends StatefulWidget {
  final String calendarType;

  const CalendarHeader({
    super.key,
    required this.calendarType,
  });

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  void _changeMonth(int increment) {
    int newMonth = PersianCalendar.currentDate.value!.month + increment;
    int newYear = PersianCalendar.currentDate.value!.year;

    // مدیریت تغییر سال و ماه
    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }

    // به‌روزرسانی تاریخ جدید
    PersianCalendar.currentDate.value = Jalali(newYear, newMonth, 1);

    // اطلاع‌رسانی تغییرات
    PersianCalendar.persianDateNotifier.value =
        PersianCalendar.getPersianDate(PersianCalendar.currentDate.value!);
    PersianCalendar.daysOfMonthNotifier.value =
        PersianCalendar.getDaysOfMonth(PersianCalendar.currentDate.value!);

    PersianCalendar.persianDateSlashNotifier.value =
        '${PersianCalendar.currentDate.value!.year}/${PersianCalendar.currentDate.value!.month}/${PersianCalendar.currentDate.value!.day}';

    // ریست کردن روز انتخاب‌شده
    PersianCalendar.selectedDayNotifier.value = null;
  }

  void _changeYear(int increment) {
    // تغییر سال و بروزرسانی تاریخ
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
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xffF1F3F5),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.only(bottom: 16),
      alignment: Alignment.center,
      child: widget.calendarType == 'day'
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BoxIncreaseDecrease(
                  onTap: () => _changeMonth(1),
                  icon: Icons.add,
                ),
                ValueListenableBuilder<String>(
                  valueListenable: PersianCalendar.persianDateNotifier,
                  builder: (context, persianDate, child) {
                    return GestureDetector(
                      onTap: () {
                        PersianCalendar.isTypeCalenderNotifier.value = 'month';
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: 150,
                        alignment: Alignment.center,
                        child: SmallMedium(
                          persianDate,
                          textColorInLight: const Color(0xff861C8C),
                        ),
                      ),
                    );
                  },
                ),
                BoxIncreaseDecrease(
                  onTap: () => _changeMonth(-1),
                  icon: Icons.remove,
                ),
              ],
            )
          : widget.calendarType == 'month'
              ? ValueListenableBuilder<String>(
                  valueListenable: PersianCalendar.persianDateNotifier,
                  builder: (context, persianDate, child) {
                    RegExp regExp = RegExp(r'\d+');
                    Match? match = regExp.firstMatch(persianDate);
                    String year = match != null ? match.group(0)! : '';

                    return GestureDetector(
                      onTap: () {
                        PersianCalendar.isTypeCalenderNotifier.value = 'year';
                      },
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: SmallMedium(
                          year,
                          textColorInLight: const Color(0xff861C8C),
                        ),
                      ),
                    );
                  },
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BoxIncreaseDecrease(
                      onTap: () => _changeYear(1),
                      icon: Icons.add,
                    ),
                    ValueListenableBuilder<String>(
                      valueListenable: PersianCalendar.persianDateNotifier,
                      builder: (context, persianDate, child) {
                        RegExp regExp = RegExp(r'\d+');
                        Match? match = regExp.firstMatch(persianDate);
                        String year = match != null ? match.group(0)! : '';

                        return SmallMedium(
                          year,
                          textColorInLight: const Color(0xff861C8C),
                        );
                      },
                    ),
                    BoxIncreaseDecrease(
                      onTap: () => _changeYear(-1),
                      icon: Icons.remove,
                    ),
                  ],
                ),
    );
  }
}
