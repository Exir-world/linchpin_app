import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/persian_calender/persian_calendar.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class PersianDatePicker extends StatefulWidget {
  final String title;
  final EdgeInsetsGeometry padding;
  final DateTime initialDate;
  final Function(
    String? persianDateSlash,
    String? persianDateHyphen,
    String? englishDateIso8601,
  )? onDateSelected;

  const PersianDatePicker({
    super.key,
    required this.initialDate,
    this.onDateSelected,
    required this.title,
    required this.padding,
  });

  @override
  State<PersianDatePicker> createState() => _PersianDatePickerState();
}

class _PersianDatePickerState extends State<PersianDatePicker> {
  late ValueNotifier<bool> isPickerOpenNotifier;
  late ValueNotifier<String?> persianDateSlashNotifier;

  @override
  void initState() {
    super.initState();
    isPickerOpenNotifier = ValueNotifier<bool>(false);
    persianDateSlashNotifier = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    isPickerOpenNotifier.dispose();
    persianDateSlashNotifier.dispose();
    super.dispose();
  }

  void _openCalendar() {
    PersianCalendar.openCalendar(
      context,
      initialDate: widget.initialDate,
      onDateSelected:
          (persianDateSlash, persianDateHyphen, englishDateIso8601) {
        persianDateSlashNotifier.value = persianDateSlash;
        widget.onDateSelected
            ?.call(persianDateSlash, persianDateHyphen, englishDateIso8601);
        _closeCalendar(); // غیرفعال کردن border بعد از انتخاب تاریخ
      },
      onCalendarStateChange: (isOpen) {
        // تغییرات وضعیت تقویم
        isPickerOpenNotifier.value = isOpen;
      },
    );
  }

  void _closeCalendar() {
    isPickerOpenNotifier.value = false;
    PersianCalendar.closeDropdown();
  }

  Future<bool> _onWillPop() async {
    if (isPickerOpenNotifier.value) {
      _closeCalendar(); // بسته شدن تقویم هنگام فشردن دکمه بک
      return false; // جلوگیری از برگشت به صفحه قبلی
    }
    return true; // اجازه برگشت به صفحه قبلی
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: () {
          if (isPickerOpenNotifier.value) {
            _closeCalendar(); // بسته شدن تقویم وقتی بیرون از آن کلیک می‌شود
          }
        },
        child: Padding(
          padding: widget.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalMedium(widget.title),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  if (isPickerOpenNotifier.value) {
                    _closeCalendar();
                  } else {
                    _openCalendar();
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: isPickerOpenNotifier,
                  builder: (context, isOpen, child) {
                    return Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isOpen
                              ? const Color(0xff861C8C)
                              : const Color(0xffE0E0F9),
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: ValueListenableBuilder(
                        valueListenable: persianDateSlashNotifier,
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
                                      "--/--/--",
                                      textColorInLight: const Color(0xffCAC4CF),
                                    )
                                  : NormalRegular(persianDateSlash),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
