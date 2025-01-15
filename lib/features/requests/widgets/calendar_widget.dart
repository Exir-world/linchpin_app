import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/gen/assets.gen.dart';
import 'package:shamsi_date/shamsi_date.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime initialDate; // تاریخ اولیه ورودی از بیرون
  const CalendarWidget({
    super.key,
    required this.initialDate,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late ValueNotifier<bool> _isCalenderOpenNotifier;
  OverlayEntry? _dropdownOverlay;
  late Jalali _currentDate;
  late ValueNotifier<String> _persianDateNotifier;
  late ValueNotifier<List<int?>> _daysOfMonthNotifier;
  late ValueNotifier<int?>
      _selectedDayNotifier; // استفاده از ValueNotifier برای ذخیره روز انتخابی

  final GlobalKey _calendarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _isCalenderOpenNotifier = ValueNotifier<bool>(false);
    _currentDate = Jalali.fromDateTime(widget.initialDate);
    _persianDateNotifier = ValueNotifier<String>(_getPersianDate(_currentDate));
    _daysOfMonthNotifier =
        ValueNotifier<List<int?>>(_getDaysOfMonth(_currentDate));
    _selectedDayNotifier = ValueNotifier<int?>(null); // مقدار اولیه null
  }

  @override
  void dispose() {
    _persianDateNotifier.dispose();
    _daysOfMonthNotifier.dispose();
    _isCalenderOpenNotifier.dispose();
    _selectedDayNotifier.dispose(); // دیس‌پوز کردن نوتیفایر جدید
    super.dispose();
  }

  int _getFirstDayOfMonth(Jalali date) {
    return date.weekDay - 1;
  }

  List<int?> _getDaysOfMonth(Jalali date) {
    int daysInMonth = date.monthLength;
    int startDay = _getFirstDayOfMonth(date);

    Jalali previousMonth = date.addMonths(-1);
    int daysInPreviousMonth = previousMonth.monthLength;

    List<int?> days = List<int?>.generate(
      startDay,
      (index) => daysInPreviousMonth - startDay + index + 1,
    );

    days.addAll(List.generate(daysInMonth, (index) => index + 1));

    int endDayCount = (7 - (days.length % 7)) % 7;

    date.addMonths(1);
    days.addAll(List.generate(endDayCount, (index) => index + 1));

    return days;
  }

  String _getPersianDate(Jalali jalaliDate) {
    String monthName = _getPersianMonth(jalaliDate.month);
    return '$monthName ${jalaliDate.year}';
  }

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

  void _closeDropdown() {
    _dropdownOverlay?.remove();
    _isCalenderOpenNotifier.value = false;
  }

  void _openCalender(BuildContext context) {
    final overlay = Overlay.of(context);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _dropdownOverlay = OverlayEntry(
      builder: (context) => Stack(
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
              child: Container(
                key: _calendarKey,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
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
                              onTap: () => _changeMonth(1),
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
                              return SmallMedium(persianDate);
                            },
                          ),
                          _BoxIncreaseDecrease(
                            icon: GestureDetector(
                              onTap: () => _changeMonth(-1),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 12),
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
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: days.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              int? day = days[index];
                              int startDay = _getFirstDayOfMonth(_currentDate);
                              int endDayStartIndex =
                                  startDay + _currentDate.monthLength;

                              bool isPreviousMonthDay = index < startDay;
                              bool isNextMonthDay = index >= endDayStartIndex;

                              return Center(
                                child: day == null
                                    ? Container()
                                    : GestureDetector(
                                        onTap: isPreviousMonthDay ||
                                                isNextMonthDay
                                            ? null // روزهای ماه‌های قبلی و بعدی نمی‌توانند انتخاب شوند
                                            : () {
                                                _selectedDayNotifier.value =
                                                    day;
                                              },
                                        child: ValueListenableBuilder<int?>(
                                          valueListenable: _selectedDayNotifier,
                                          builder:
                                              (context, selectedDay, child) {
                                            return Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                // تنها برای روزهای ماه جاری استایل انتخاب‌شده تغییر می‌کند
                                                color: (selectedDay == day &&
                                                        !isPreviousMonthDay &&
                                                        !isNextMonthDay)
                                                    ? Color(
                                                        0xff861C8C) // رنگ پس‌زمینه روز انتخاب‌شده
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: NormalMedium(
                                                '$day',
                                                textColorInLight:
                                                    isPreviousMonthDay ||
                                                            isNextMonthDay
                                                        ? Colors
                                                            .grey // رنگ خاکی برای روزهای ماه‌های دیگر
                                                        : (selectedDay == day
                                                            ? Colors.white
                                                            : Color(
                                                                0xff030712)),
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
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_dropdownOverlay!);
    _isCalenderOpenNotifier.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                    _openCalender(context);
                  } else {
                    _closeDropdown();
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
                      NormalRegular(
                        "تاریخ",
                        textColorInLight: Color(0xffCAC4CF),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

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
            color: Color(0xff030712).withValues(alpha: .12),
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
