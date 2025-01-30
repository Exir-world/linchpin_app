import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/gen/assets.gen.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'day_view.dart';
import 'month_view.dart';
import 'year_view.dart';

/// ویجت اصلی PersianCalendar که به عنوان یک تقویم شمسی عمل می‌کند.
/// این ویجت به کاربر امکان انتخاب تاریخ شمسی و میلادی را می‌دهد و تاریخ‌های انتخابی را از طریق یک callback به بیرون ارسال می‌کند.
class PersianCalendar extends StatefulWidget {
  /// تاریخ اولیه که از بیرون به ویجت ارسال می‌شود.
  final DateTime initialDate;

  /// Callback که برای ارسال تاریخ‌های انتخاب‌شده به بیرون از ویجت استفاده می‌شود.
  final Function(
    String? persianDateSlash, // تاریخ شمسی با فرمت اسلش.
    String? persianDateHyphen, // تاریخ شمسی با فرمت خط فاصله.
    String? englishDateIso8601, // تاریخ میلادی با فرمت ISO8601.
  )? onDateSelected;

  const PersianCalendar({
    super.key,
    required this.initialDate, // مقدار اولیه تاریخ که از بیرون وارد می‌شود.
    this.onDateSelected, // می‌توان این callback را به دلخواه ارسال کرد.
  });

  /// نوتیفایر برای بررسی وضعیت باز یا بسته بودن تقویم.
  static final ValueNotifier<bool> isCalenderOpenNotifier =
      ValueNotifier<bool>(false);

  /// نوتیفایر برای ذخیره تاریخ شمسی جاری که در UI منعکس می‌شود.
  static final ValueNotifier<String> persianDateNotifier =
      ValueNotifier<String>('');

  /// نوتیفایر برای ذخیره لیست روزهای ماه جاری.
  static final ValueNotifier<List<int?>> daysOfMonthNotifier =
      ValueNotifier<List<int?>>([]);

  /// نوتیفایر برای ذخیره روز انتخاب‌شده.
  static final ValueNotifier<int?> selectedDayNotifier =
      ValueNotifier<int?>(null);

  /// نوتیفایر برای نوع نمایش تقویم (روز، ماه، سال).
  static final ValueNotifier<String> isTypeCalenderNotifier =
      ValueNotifier<String>('day');

  static final ValueNotifier<String?> persianDateSlashNotifier =
      ValueNotifier<String?>(null);

  static ValueNotifier<OverlayEntry?> dropdownOverlay = ValueNotifier(null);

  static ValueNotifier<Jalali?> currentDate = ValueNotifier(null);

  /// تغییر سال با افزایش یا کاهش مقدار.
  /// این متد سال جاری را تغییر می‌دهد و اطلاعات تاریخ و روزها را به‌روزرسانی می‌کند.
  static void changeYear(Jalali currentDate, int increment) {
    final newDate = currentDate.addYears(increment);
    persianDateNotifier.value = getPersianDate(newDate);
    daysOfMonthNotifier.value = getDaysOfMonth(newDate);
    selectedDayNotifier.value = null;
  }

  /// تغییر ماه با افزایش یا کاهش مقدار.
  /// این متد ماه جاری را تغییر می‌دهد و اطلاعات تاریخ و روزها را به‌روزرسانی می‌کند.
  static void changeMonth(Jalali currentDate, int increment) {
    final newDate = currentDate.addMonths(increment);
    persianDateNotifier.value = getPersianDate(newDate);
    daysOfMonthNotifier.value = getDaysOfMonth(newDate);
    selectedDayNotifier.value = null;
  }

  /// بستن باکس Dropdown تقویم.
  /// این متد، باکس تقویم باز شده را می‌بندد.
  static void closeDropdown(OverlayEntry? dropdownOverlay) {
    if (dropdownOverlay != null) {
      dropdownOverlay.remove();
      isCalenderOpenNotifier.value = false;
      selectedDayNotifier.value = null;
    }
  }

  /// دریافت نام ماه شمسی بر اساس شماره ماه.
  /// این متد، نام ماه شمسی را برای یک شماره ماه خاص برمی‌گرداند.
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

  /// تولید تاریخ شمسی از یک تاریخ جلالی.
  /// این متد، تاریخ جلالی را به فرمت شمسی تبدیل می‌کند.
  static String getPersianDate(Jalali jalaliDate) {
    String monthName = getPersianMonth(jalaliDate.month);
    return '$monthName ${jalaliDate.year}';
  }

  /// پیدا کردن اولین روز ماه به‌صورت روز هفته.
  /// این متد روز هفته اولین روز ماه را پیدا می‌کند.
  static int getFirstDayOfMonth(Jalali date) {
    return date.weekDay - 1;
  }

  /// تولید لیست روزهای ماه جاری.
  /// این متد، لیست روزهای ماه جاری را تولید می‌کند، شامل روزهای قبل و بعد از ماه جاری.
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

  @override
  State<PersianCalendar> createState() => _PersianCalendarState();
}

/// کلاس State مربوط به ویجت PersianCalendar که مدیریت وضعیت و رفتارهای داخلی تقویم را انجام می‌دهد.
class _PersianCalendarState extends State<PersianCalendar> {
  @override
  void initState() {
    super.initState();
    PersianCalendar.currentDate.value = null; // مقداردهی اولیه تاریخ
    PersianCalendar.persianDateSlashNotifier.value = null;
    PersianCalendar.currentDate.value =
        Jalali.fromDateTime(widget.initialDate); // تنظیم تاریخ اولیه
    PersianCalendar.currentDate.value = Jalali(
        PersianCalendar.currentDate.value!.year,
        PersianCalendar.currentDate.value!.month,
        1);

    // مقداردهی اولیه نوتیفایرها
    PersianCalendar.persianDateNotifier.value =
        PersianCalendar.getPersianDate(PersianCalendar.currentDate.value!);
    PersianCalendar.daysOfMonthNotifier.value =
        PersianCalendar.getDaysOfMonth(PersianCalendar.currentDate.value!);
  }

  /// باز کردن تقویم و نمایش حالت جاری آن.
  /// این متد تقویم را به‌صورت Dropdown نمایش می‌دهد.
  void _openCalender(BuildContext context) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    PersianCalendar.dropdownOverlay.value = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => PersianCalendar.closeDropdown(
                  PersianCalendar.dropdownOverlay.value),
              behavior: HitTestBehavior.opaque,
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy + renderBox.size.height + 8,
            width: renderBox.size.width,
            child: Material(
              color: Colors.transparent,
              child: ValueListenableBuilder(
                valueListenable: PersianCalendar.isTypeCalenderNotifier,
                builder: (context, type, child) {
                  if (type == 'day') {
                    return DayView(
                        onDateSelected: widget.onDateSelected); // نمایش روزها
                  } else if (type == 'month') {
                    return MonthView(); // نمایش ماه‌ها
                  } else if (type == 'year') {
                    return YearView(); // نمایش سال‌ها
                  } else {
                    return Container(); // نمایش هیچ‌چیز
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(PersianCalendar.dropdownOverlay.value!);
    PersianCalendar.isCalenderOpenNotifier.value = true; // تقویم باز شده است
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (PersianCalendar.isCalenderOpenNotifier.value) {
          PersianCalendar.closeDropdown(PersianCalendar.dropdownOverlay.value);
          return false;
        }
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalMedium('تاریخ'),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // زمانی که کاربر خارج از متن کلیک کند، فوکوس برداشته می‌شود
              FocusScope.of(context).requestFocus(FocusNode());
              if (!PersianCalendar.isCalenderOpenNotifier.value) {
                PersianCalendar.daysOfMonthNotifier.value =
                    PersianCalendar.getDaysOfMonth(
                        PersianCalendar.currentDate.value!);
                _openCalender(context);
              } else {
                PersianCalendar.closeDropdown(
                    PersianCalendar.dropdownOverlay.value);
              }
            },
            child: ValueListenableBuilder(
              valueListenable: PersianCalendar.isCalenderOpenNotifier,
              builder: (context, value, child) {
                return Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: PersianCalendar.isCalenderOpenNotifier.value
                          ? const Color(0xff861C8C)
                          : const Color(0xffE0E0F9),
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: ValueListenableBuilder(
                    valueListenable: PersianCalendar.persianDateNotifier,
                    builder: (context, value, child) {
                      return ValueListenableBuilder(
                        valueListenable:
                            PersianCalendar.persianDateSlashNotifier,
                        builder: (context, persianDateSlash, child) {
                          return Row(
                            children: [
                              Assets.icons.calendar.svg(
                                colorFilter: const ColorFilter.mode(
                                    Color(0xffCAC4CF), BlendMode.srcIn),
                              ),
                              const SizedBox(width: 8),
                              persianDateSlash == null
                                  ? NormalRegular(
                                      "تاریخ",
                                      textColorInLight: const Color(0xffCAC4CF),
                                    )
                                  : NormalRegular(persianDateSlash),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
