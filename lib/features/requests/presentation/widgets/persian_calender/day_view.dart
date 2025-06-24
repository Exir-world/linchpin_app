import 'package:flutter/material.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/persian_calender/calendar_header.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/persian_calender/persian_calendar.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';

/// ویجت DayView که روزهای ماه را نمایش می‌دهد.
/// این ویجت به کاربر این امکان را می‌دهد که یک روز خاص را از تقویم انتخاب کند
/// و تاریخ انتخابی را به خارج از ویجت ارسال نماید.
class DayView extends StatefulWidget {
  /// کال‌بک برای ارسال تاریخ‌های مختلف به خارج از ویجت
  final Function(
    String? persianDateSlash,
    String? persianDateHyphen,
    String? englishDateIso8601,
  )? onDateSelected;

  const DayView({super.key, this.onDateSelected});

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  /// متد selectDay برای انتخاب روز خاص و ارسال تاریخ به خارج از ویجت.
  /// این متد تاریخ‌های مختلف (فارسی و انگلیسی) را به فرمت‌های مختلف تبدیل کرده
  /// و به کال‌بک ارسال می‌کند.
  void selectDay(int day) {
    // ایجاد تاریخ جدید بر اساس روز انتخاب‌شده
    final selectedDate = Jalali(
      PersianCalendar.currentDate.value!.year,
      PersianCalendar.currentDate.value!.month,
      day,
    );
    final englishDate = selectedDate.toDateTime();

    // فرمت‌بندی تاریخ به شکل‌های مختلف
    final persianDateSlash =
        '${PersianCalendar.currentDate.value!.year}/${PersianCalendar.currentDate.value!.month}/$day';
    final persianDateHyphen =
        '${PersianCalendar.currentDate.value!.year}-${PersianCalendar.currentDate.value!.month}-$day';
    final englishDateIso8601 = englishDate.toUtc().toIso8601String();

    // بروزرسانی نوتیفایرهای تقویم
    PersianCalendar.persianDateSlashNotifier.value =
        persianDateSlash; // به‌روزرسانی تاریخ فارسی با جداکننده اسلش
    PersianCalendar.selectedDayNotifier.value = day;

    // ارسال تاریخ‌های مختلف به کال‌بک
    widget.onDateSelected?.call(
      persianDateSlash,
      persianDateHyphen,
      englishDateIso8601,
    );

    // بستن منوی کشویی تقویم پس از انتخاب تاریخ
    PersianCalendar.closeDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360, // ارتفاع ویجت DayView
      decoration: BoxDecoration(
        color: Colors.white, // رنگ پس‌زمینه
        borderRadius: BorderRadius.circular(8), // گوشه‌های گرد
      ),
      padding: const EdgeInsets.all(12), // فاصله داخلی
      child: Column(
        children: [
          // هدر تقویم
          const CalendarHeader(calendarType: 'day'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // فاصله مساوی بین روزهای هفته
              children: [
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
          // نمایش روزهای ماه در یک Grid
          Expanded(
            child: ValueListenableBuilder<List<int?>>(
              valueListenable: PersianCalendar.daysOfMonthNotifier,
              builder: (context, days, child) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, // تعداد ستون‌ها برابر با روزهای هفته
                    childAspectRatio: 1.0, // تناسب ابعاد هر خانه
                  ),
                  itemCount: days.length, // تعداد روزهای ماه
                  padding: EdgeInsets.zero, // حذف فاصله داخلی
                  itemBuilder: (context, index) {
                    int? day = days[index]; // روز جاری در ایندکس مشخص
                    int startDay = PersianCalendar.getFirstDayOfMonth(
                      PersianCalendar.currentDate.value!,
                    ); // روز شروع ماه
                    int endDayStartIndex = startDay +
                        PersianCalendar
                            .currentDate.value!.monthLength; // آخرین روز ماه
                    bool isPreviousMonthDay =
                        index < startDay; // آیا این روز از ماه قبلی است؟
                    bool isNextMonthDay = index >=
                        endDayStartIndex; // آیا این روز از ماه بعدی است؟

                    return Center(
                      child: day == null
                          ? Container() // اگر روز نباشد، هیچ چیزی نمایش داده نمی‌شود
                          : GestureDetector(
                              onTap: isPreviousMonthDay || isNextMonthDay
                                  ? null // اگر روز متعلق به ماه قبلی یا بعدی باشد، قابلیت انتخاب ندارد
                                  : () {
                                      selectDay(day); // انتخاب روز
                                    },
                              child: ValueListenableBuilder<int?>(
                                valueListenable:
                                    PersianCalendar.selectedDayNotifier,
                                builder: (context, selectedDay, child) {
                                  return Container(
                                    width: double.infinity, // عرض خانه
                                    height: double.infinity, // ارتفاع خانه
                                    alignment: Alignment
                                        .center, // تراز کردن روز در مرکز
                                    margin: const EdgeInsets.all(
                                      6,
                                    ), // فاصله بین خانه‌ها
                                    decoration: BoxDecoration(
                                      color: (selectedDay == day &&
                                              !isPreviousMonthDay &&
                                              !isNextMonthDay)
                                          ? const Color(
                                              0xff861C8C,
                                            ) // رنگ پس‌زمینه روز انتخابی
                                          : null,
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ), // گوشه‌های گرد
                                    ),
                                    child: NormalMedium(
                                      '$day', // نمایش روز
                                      textColorInLight: isPreviousMonthDay ||
                                              isNextMonthDay
                                          ? Colors
                                              .grey // رنگ خاکستری برای روزهای ماه‌های قبلی یا بعدی
                                          : (selectedDay == day
                                              ? Colors
                                                  .white // رنگ سفید برای روز انتخابی
                                              : const Color(
                                                  0xff030712,
                                                )), // رنگ پیش‌فرض برای روزهای دیگر
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
