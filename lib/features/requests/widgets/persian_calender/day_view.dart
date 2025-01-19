import 'package:flutter/material.dart';
import 'package:linchpin_app/features/requests/widgets/persian_calender/calendar_header.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'persian_calendar.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';

class DayView extends StatefulWidget {
  final Function(
    String? persianDateSlash,
    String? persianDateHyphen,
    String? englishDateIso8601,
  )? onDateSelected; // تعریف callback
  const DayView({super.key, this.onDateSelected});

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  /// انتخاب روز خاص و ارسال اطلاعات تاریخ به بیرون از ویجت.
  void selectDay(int day) {
    final selectedDate = Jalali(PersianCalendar.currentDate.value!.year,
        PersianCalendar.currentDate.value!.month, day);
    final englishDate = selectedDate.toDateTime();

    // مقداردهی به فرمت‌های مختلف تاریخ
    final persianDateSlash =
        '${PersianCalendar.currentDate.value!.year}/${PersianCalendar.currentDate.value!.month}/$day';
    final persianDateHyphen =
        '${PersianCalendar.currentDate.value!.year}-${PersianCalendar.currentDate.value!.month}-$day';
    final englishDateIso8601 = englishDate.toUtc().toIso8601String();

    // بروزرسانی نوتیفایرها
    PersianCalendar.persianDateSlashNotifier.value =
        persianDateSlash; // اضافه شده
    PersianCalendar.selectedDayNotifier.value = day;

    // ارسال تاریخ به Callback
    widget.onDateSelected?.call(
      persianDateSlash,
      persianDateHyphen,
      englishDateIso8601,
    );

    // بستن Dropdown تقویم
    PersianCalendar.closeDropdown(PersianCalendar.dropdownOverlay.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Header
          CalendarHeader(calendarType: 'day'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SmallMedium('ش', textColorInLight: Color(0xff9CA3AF)),
                SmallMedium('ی', textColorInLight: Color(0xff9CA3AF)),
                SmallMedium('د', textColorInLight: Color(0xff9CA3AF)),
                SmallMedium('س', textColorInLight: Color(0xff9CA3AF)),
                SmallMedium('چ', textColorInLight: Color(0xff9CA3AF)),
                SmallMedium('پ', textColorInLight: Color(0xff9CA3AF)),
                SmallMedium('ج', textColorInLight: Color(0xff9CA3AF)),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<int?>>(
              valueListenable: PersianCalendar.daysOfMonthNotifier,
              builder: (context, days, child) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: days.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    int? day = days[index];
                    int startDay = PersianCalendar.getFirstDayOfMonth(
                        PersianCalendar.currentDate.value!);
                    int endDayStartIndex = startDay +
                        PersianCalendar.currentDate.value!.monthLength;
                    bool isPreviousMonthDay = index < startDay;
                    bool isNextMonthDay = index >= endDayStartIndex;

                    return Center(
                      child: day == null
                          ? Container()
                          : GestureDetector(
                              onTap: isPreviousMonthDay || isNextMonthDay
                                  ? null
                                  : () {
                                      selectDay(day);
                                    },
                              child: ValueListenableBuilder<int?>(
                                valueListenable:
                                    PersianCalendar.selectedDayNotifier,
                                builder: (context, selectedDay, child) {
                                  return Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: (selectedDay == day &&
                                              !isPreviousMonthDay &&
                                              !isNextMonthDay)
                                          ? const Color(0xff861C8C)
                                          : null,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: NormalMedium(
                                      '$day',
                                      textColorInLight:
                                          isPreviousMonthDay || isNextMonthDay
                                              ? Colors.grey
                                              : (selectedDay == day
                                                  ? Colors.white
                                                  : const Color(0xff030712)),
                                    ),
                                  );
                                },
                              ),
                            ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
