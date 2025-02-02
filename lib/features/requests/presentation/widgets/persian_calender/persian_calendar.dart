import 'package:flutter/material.dart';
import 'package:linchpin_app/core/extension/context_extension.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'day_view.dart';
import 'month_view.dart';
import 'year_view.dart';

/// ویجت اصلی PersianCalendar که به عنوان یک تقویم شمسی عمل می‌کند.
/// این ویجت به کاربر امکان انتخاب تاریخ شمسی و میلادی را می‌دهد و تاریخ‌های انتخابی را از طریق یک callback به بیرون ارسال می‌کند.
class PersianCalendar {
  static final ValueNotifier<bool> isCalenderOpenNotifier =
      ValueNotifier<bool>(false);
  static final ValueNotifier<String> persianDateNotifier =
      ValueNotifier<String>('');
  static final ValueNotifier<List<int?>> daysOfMonthNotifier =
      ValueNotifier<List<int?>>([]);
  static final ValueNotifier<int?> selectedDayNotifier =
      ValueNotifier<int?>(null);
  static final ValueNotifier<String> isTypeCalenderNotifier =
      ValueNotifier<String>('day');
  static final ValueNotifier<String?> persianDateSlashNotifier =
      ValueNotifier<String?>(null);
  static ValueNotifier<OverlayEntry?> dropdownOverlay = ValueNotifier(null);
  static ValueNotifier<Jalali?> currentDate = ValueNotifier(null);

  /// مقداردهی اولیه نوتیفایرها
  static void initialize(DateTime initialDate) {
    currentDate.value = Jalali.fromDateTime(initialDate);
    currentDate.value =
        Jalali(currentDate.value!.year, currentDate.value!.month, 1);

    persianDateNotifier.value = getPersianDate(currentDate.value!);
    daysOfMonthNotifier.value = getDaysOfMonth(currentDate.value!);
  }

  /// باز کردن `Overlay` تقویم و اطلاع‌رسانی تغییر وضعیت
  static void openCalendar(
    BuildContext context, {
    required DateTime initialDate,
    Function(
      String? persianDateSlash,
      String? persianDateHyphen,
      String? englishDateIso8601,
    )? onDateSelected,
    Function(bool)? onCalendarStateChange, // پارامتر جدید
  }) {
    initialize(initialDate);

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = context.screenHeight;
    const calendarHeight = 300.0; // ارتفاع تقریبی تقویم

    // بررسی اینکه آیا فضای کافی در پایین صفحه وجود دارد
    final bool hasEnoughSpaceBelow =
        (position.dy + renderBox.size.height + 8 + calendarHeight) <
            screenHeight;

    dropdownOverlay.value = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                closeDropdown();
                if (onCalendarStateChange != null) {
                  onCalendarStateChange(false); // تغییر وضعیت تقویم
                }
              },
              behavior: HitTestBehavior.opaque,
            ),
          ),
          Positioned(
            left: position.dx,
            top: hasEnoughSpaceBelow
                ? position.dy + renderBox.size.height - 8 // نمایش پایین
                : position.dy - calendarHeight - 8, // نمایش بالا
            width: renderBox.size.width,
            child: Material(
              color: Colors.transparent,
              child: ValueListenableBuilder(
                valueListenable: isTypeCalenderNotifier,
                builder: (context, type, child) {
                  if (type == 'day') {
                    return DayView(onDateSelected: onDateSelected);
                  } else if (type == 'month') {
                    return MonthView();
                  } else if (type == 'year') {
                    return YearView();
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(dropdownOverlay.value!);
    isCalenderOpenNotifier.value = true;

    if (onCalendarStateChange != null) {
      onCalendarStateChange(true); // تغییر وضعیت تقویم به باز
    }
  }

  /// بستن `Overlay` تقویم
  static void closeDropdown() {
    if (dropdownOverlay.value != null) {
      dropdownOverlay.value!.remove();
      isCalenderOpenNotifier.value = false;
      selectedDayNotifier.value = null;
      dropdownOverlay.value = null;
    }
  }

  /// دریافت نام ماه شمسی
  static String getPersianMonth(int month) {
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
    return months[month - 1];
  }

  /// تولید تاریخ شمسی
  static String getPersianDate(Jalali jalaliDate) {
    String monthName = getPersianMonth(jalaliDate.month);
    return '$monthName ${jalaliDate.year}';
  }

  /// پیدا کردن اولین روز ماه
  static int getFirstDayOfMonth(Jalali date) {
    return date.weekDay - 1;
  }

  /// دریافت لیست روزهای ماه
  static List<int?> getDaysOfMonth(Jalali date) {
    int daysInMonth = date.monthLength;
    int startDay = getFirstDayOfMonth(date);
    Jalali previousMonth = date.addMonths(-1);
    int daysInPreviousMonth = previousMonth.monthLength;

    List<int?> days = [];
    if (startDay != 0) {
      days = List<int?>.generate(
        startDay,
        (index) => daysInPreviousMonth - startDay + index + 1,
      );
    }

    days.addAll(List.generate(daysInMonth, (index) => index + 1));

    int endDayCount = (7 - (days.length % 7)) % 7;
    days.addAll(List.generate(endDayCount, (index) => index + 1));

    return days;
  }
}
