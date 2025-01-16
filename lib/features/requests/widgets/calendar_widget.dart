import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/gen/assets.gen.dart';
import 'package:shamsi_date/shamsi_date.dart';

class PersianCalendar extends StatefulWidget {
  final DateTime initialDate; // تاریخ اولیه ورودی از بیرون
  final Function(
    String? persianDateSlash,
    String? persianDateHyphen,
    String? englishDateIso8601,
  )? onDateSelected;
  const PersianCalendar({
    super.key,
    required this.initialDate, // نیاز به تاریخ ابتدایی برای راه‌اندازی ویجت
    this.onDateSelected,
  });

  @override
  State<PersianCalendar> createState() => _PersianCalendarState();
}

class _PersianCalendarState extends State<PersianCalendar> {
  // نوتیفایرها برای مدیریت وضعیت‌های مختلف
  late ValueNotifier<bool> _isCalenderOpenNotifier; // وضعیت باز بودن تقویم
  OverlayEntry? _dropdownOverlay; // برای اضافه کردن ویجت تقویم به صفحه
  late Jalali _currentDate; // تاریخ جاری به فرمت جلالی
  late ValueNotifier<String> _persianDateNotifier; // نوتیفایر برای تاریخ شمسی
  late ValueNotifier<List<int?>>
      _daysOfMonthNotifier; // نوتیفایر برای روزهای ماه جاری
  late ValueNotifier<int?> _selectedDayNotifier; // نوتیفایر برای روز انتخاب‌شده
  late ValueNotifier<String>
      _isTypeCalenderNotifier; // نوتیفایر برای نوع تقویم (روز، ماه، سال)

  final GlobalKey _calendarKey = GlobalKey(); // کلید برای شناسایی ویجت تقویم
  String? _persianDateSlash;
  String? _persianDateHyphen;
  DateTime? _englishDate;
  String? _englishDateIso8601;
  @override
  void initState() {
    super.initState();

    _isCalenderOpenNotifier = ValueNotifier<bool>(false);
    // تنظیم تاریخ شمسی از تاریخ ورودی
    _currentDate = Jalali.fromDateTime(widget.initialDate);
    // بررسی ماه و سال تاریخ ورودی
    _currentDate = Jalali(_currentDate.year, _currentDate.month, 1);
    _persianDateNotifier = ValueNotifier<String>(_getPersianDate(_currentDate));
    _daysOfMonthNotifier =
        ValueNotifier<List<int?>>(_getDaysOfMonth(_currentDate));
    _selectedDayNotifier = ValueNotifier<int?>(null);
    _isTypeCalenderNotifier = ValueNotifier<String>('day');
  }

  @override
  void dispose() {
    // پاکسازی نوتیفایرها هنگام از بین رفتن ویجت
    _persianDateNotifier.dispose();
    _daysOfMonthNotifier.dispose();
    _isCalenderOpenNotifier.dispose();
    _selectedDayNotifier.dispose();
    _isTypeCalenderNotifier.dispose();
    super.dispose();
  }

  // وقتی تاریخ جدیدی انتخاب می‌شود، این متد صدا می‌شود
  void _onDateSelected(String? persianDateSlash, String? persianDateHyphen,
      String? englishDateIso8601) {
    setState(() {
      _persianDateSlash = persianDateSlash;
      _persianDateHyphen = persianDateHyphen;

      _englishDateIso8601 = englishDateIso8601;
    });

    // ارسال تاریخ به بیرون از ویجت از طریق callback
    if (widget.onDateSelected != null) {
      widget.onDateSelected!(
        _persianDateSlash,
        _persianDateHyphen,
        _englishDateIso8601,
      );
    }
  }

  // محاسبه اولین روز ماه (روز هفته)
  int _getFirstDayOfMonth(Jalali date) {
    return date.weekDay - 1;
  }

  // گرفتن لیست روزهای ماه جاری
  List<int?> _getDaysOfMonth(Jalali date) {
    int daysInMonth = date.monthLength;
    int startDay = _getFirstDayOfMonth(date);

    // شرط برای بررسی اینکه آیا ماه از شنبه شروع می‌شود یا نه
    bool startsOnSaturday = startDay == 0;

    Jalali previousMonth = date.addMonths(-1);
    int daysInPreviousMonth = previousMonth.monthLength;

    List<int?> days = [];

    // اگر ماه از شنبه شروع نشود، روزهای ماه قبلی نمایش داده می‌شوند
    if (!startsOnSaturday) {
      days = List<int?>.generate(
        startDay,
        (index) => daysInPreviousMonth - startDay + index + 1,
      );
    }

    // اضافه کردن روزهای ماه جاری
    days.addAll(List.generate(daysInMonth, (index) => index + 1));

    // روزهای باقی‌مانده از ماه بعد
    int endDayCount = (7 - (days.length % 7)) % 7;
    date.addMonths(1);
    days.addAll(List.generate(endDayCount, (index) => index + 1));

    return days;
  }

  // تبدیل تاریخ جلالی به فرمت قابل نمایش
  String _getPersianDate(Jalali jalaliDate) {
    String monthName = _getPersianMonth(jalaliDate.month);
    return '$monthName ${jalaliDate.year}';
  }

  // گرفتن نام ماه فارسی
  String _getPersianMonth(int month) {
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

  void _changeCalendarType(String newType) {
    setState(() {
      _isTypeCalenderNotifier.value = newType;
      _selectedDayNotifier.value = null; // ریست کردن روز انتخاب‌شده
    });
  }

  // تغییر ماه به جلو یا عقب
  void _changeMonth(int increment) {
    setState(() {
      int newMonth = _currentDate.month + increment;
      int newYear = _currentDate.year;

      if (newMonth > 12) {
        newMonth = 1;
        newYear++;
      } else if (newMonth < 1) {
        newMonth = 12;
        newYear--;
      }

      // تغییر ماه و سال
      _currentDate = Jalali(newYear, newMonth, 1);
      _persianDateNotifier.value = _getPersianDate(_currentDate);
      _daysOfMonthNotifier.value = _getDaysOfMonth(_currentDate);

      // ریست کردن روز انتخاب‌شده به null
      _selectedDayNotifier.value = null;
    });
  }

  // بستن dropdown تقویم
  void _closeDropdown() {
    _dropdownOverlay?.remove();
    _isCalenderOpenNotifier.value = false;
  }

  // باز کردن تقویم
  void _openCalender(BuildContext context) {
    final overlay = Overlay.of(context);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _dropdownOverlay = OverlayEntry(
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeDropdown,
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
                  valueListenable: _isTypeCalenderNotifier,
                  builder: (context, type, child) {
                    if (type == 'day') {
                      return _buildDayView();
                    } else if (type == 'month') {
                      return _buildMonthView();
                    } else if (type == 'year') {
                      return _buildYearView();
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_dropdownOverlay!);
    _isCalenderOpenNotifier.value = true;
  }

  Widget _buildDayView() {
    return Container(
      key: _calendarKey,
      height: 360,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          // پنل انتخاب ماه
          Container(
            decoration: BoxDecoration(
              color: Color(0xffF1F3F5),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.all(2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BoxIncreaseDecrease(
                  icon: GestureDetector(
                    onTap: () => _changeMonth(1), // ماه به جلو
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: Color(0xff4B5563),
                    ),
                  ),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _persianDateNotifier,
                  builder: (context, persianDate, child) {
                    return GestureDetector(
                        onTap: () {
                          if (_isTypeCalenderNotifier.value == 'day') {
                            _changeCalendarType('month');
                          } else if (_isTypeCalenderNotifier.value == 'month') {
                            _changeCalendarType('year');
                          }
                        },
                        child: SmallMedium(persianDate));
                  },
                ),
                _BoxIncreaseDecrease(
                  icon: GestureDetector(
                    onTap: () => _changeMonth(-1), // ماه به عقب
                    child: Icon(
                      Icons.remove,
                      size: 20,
                      color: Color(0xff4B5563),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Expanded(
            child: ValueListenableBuilder<List<int?>>(
              valueListenable: _daysOfMonthNotifier,
              builder: (context, days, child) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: days.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    int? day = days[index];
                    int startDay = _getFirstDayOfMonth(_currentDate);
                    int endDayStartIndex = startDay + _currentDate.monthLength;

                    bool isPreviousMonthDay = index < startDay;
                    bool isNextMonthDay = index >= endDayStartIndex;

                    return Center(
                      child: day == null
                          ? Container()
                          : GestureDetector(
                              onTap: isPreviousMonthDay || isNextMonthDay
                                  ? null
                                  : () {
                                      _selectedDayNotifier.value = day;
                                      _persianDateSlash =
                                          "${_currentDate.year}/${_currentDate.month}/$day";
                                      _persianDateHyphen =
                                          "${_currentDate.year}-${_currentDate.month}-$day";

                                      Jalali persianDatet = Jalali(
                                          _currentDate.year,
                                          _currentDate.month,
                                          day);
                                      // تبدیل به تاریخ میلادی
                                      _englishDate = persianDatet.toDateTime();
                                      _englishDateIso8601 = _englishDate
                                          ?.toUtc()
                                          .toIso8601String();
                                      _onDateSelected(
                                        _persianDateSlash,
                                        _persianDateHyphen,
                                        _englishDateIso8601,
                                      );
                                      _closeDropdown();
                                    },
                              child: ValueListenableBuilder<int?>(
                                valueListenable: _selectedDayNotifier,
                                builder: (context, selectedDay, child) {
                                  return Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: (selectedDay == day &&
                                              !isPreviousMonthDay &&
                                              !isNextMonthDay)
                                          ? Color(0xff861C8C)
                                          : null,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: NormalMedium(
                                      '$day',
                                      textColorInLight:
                                          isPreviousMonthDay || isNextMonthDay
                                              ? Colors.grey
                                              : (selectedDay == day
                                                  ? Colors.white
                                                  : Color(0xff030712)),
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

  Widget _buildMonthView() {
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
      key: _calendarKey,
      height: 360,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double spacing = 8.0; // فاصله بین آیتم‌ها
                int crossAxisCount = 4; // تعداد ستون‌ها
                double itemWidth =
                    (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                        crossAxisCount;
                double itemHeight = itemWidth;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  direction: Axis.vertical,
                  children: List.generate(months.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        _currentDate = Jalali(_currentDate.year, index + 1, 1);
                        _isTypeCalenderNotifier.value = 'day';
                        _persianDateNotifier.value =
                            _getPersianDate(_currentDate);
                        _daysOfMonthNotifier.value =
                            _getDaysOfMonth(_currentDate);
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

  Widget _buildHeader() {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Color(0xffF1F3F5),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.only(bottom: 16),
      alignment: Alignment.center,
      child: ValueListenableBuilder<String>(
        valueListenable: _persianDateNotifier,
        builder: (context, persianDate, child) {
          return GestureDetector(
            onTap: () {
              if (_isTypeCalenderNotifier.value == 'day') {
                _isTypeCalenderNotifier.value = 'month';
              } else if (_isTypeCalenderNotifier.value == 'month') {
                _isTypeCalenderNotifier.value = 'year';
              }
            },
            child: Text(persianDate),
          );
        },
      ),
    );
  }

  List<int> _getYearsForView() {
    int currentYear = _currentDate.year;
    return List.generate(
        12, (index) => currentYear + index); // فقط سال جاری و 11 سال بعد
  }

  Widget _buildYearView() {
    return Container(
      key: _calendarKey,
      height: 360,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: Color(0xffF1F3F5),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BoxIncreaseDecrease(
                  icon: GestureDetector(
                    onTap: () => _changeYear(1), // ماه به جلو
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: Color(0xff4B5563),
                    ),
                  ),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _persianDateNotifier,
                  builder: (context, persianDate, child) {
                    return GestureDetector(
                      onTap: () {
                        if (_isTypeCalenderNotifier.value == 'day') {
                          _isTypeCalenderNotifier.value = 'month';
                        } else if (_isTypeCalenderNotifier.value == 'month') {
                          _isTypeCalenderNotifier.value = 'year';
                        }
                      },
                      child: Text(persianDate),
                    );
                  },
                ),
                _BoxIncreaseDecrease(
                  icon: GestureDetector(
                    onTap: () => _changeYear(-1), // ماه به جلو
                    child: Icon(
                      Icons.remove,
                      size: 20,
                      color: Color(0xff4B5563),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _daysOfMonthNotifier,
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
                            setState(() {
                              _currentDate =
                                  Jalali(year, _currentDate.month, 1);
                              _isTypeCalenderNotifier.value = 'month';
                            });
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

  void _changeYear(int increment) {
    setState(() {
      // تغییر سال و بروزرسانی تاریخ
      _currentDate =
          Jalali(_currentDate.year + increment, _currentDate.month, 1);

      // بروزرسانی تاریخ فارسی
      _persianDateNotifier.value = _getPersianDate(_currentDate);

      // بروزرسانی روزهای ماه جدید
      _daysOfMonthNotifier.value = _getDaysOfMonth(_currentDate);

      // ریست کردن روز انتخاب‌شده به null
      _selectedDayNotifier.value = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          if (_isCalenderOpenNotifier.value) {
            _closeDropdown();
            return false;
          }
          return true;
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: _isCalenderOpenNotifier,
          builder: (context, isOpen, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NormalMedium('تاریخ'),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    if (!isOpen) {
                      _getDaysOfMonth(_currentDate);
                      _openCalender(context); // باز کردن تقویم
                    } else {
                      _closeDropdown(); // بستن تقویم
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isOpen ? Color(0xff861C8C) : Color(0xffE0E0F9),
                      ),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Assets.icons.calendar.svg(
                          colorFilter: ColorFilter.mode(
                              Color(0xffCAC4CF), BlendMode.srcIn),
                        ),
                        SizedBox(width: 8),
                        _persianDateSlash == null
                            ? NormalRegular(
                                "تاریخ",
                                textColorInLight: Color(0xffCAC4CF),
                              )
                            : NormalRegular(_persianDateSlash!),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ویجت برای تغییر ماه با آیکون‌های افزایش و کاهش
class _BoxIncreaseDecrease extends StatelessWidget {
  final Widget? icon;
  const _BoxIncreaseDecrease({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            color: Color(0xff030712).withValues(alpha: 0.12),
            blurRadius: 2,
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(6),
      child: icon,
    );
  }
}
