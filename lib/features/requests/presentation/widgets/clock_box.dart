import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/gen/assets.gen.dart';
import 'package:linchpin_app/gen/fonts.gen.dart';

class ClockBox extends StatefulWidget {
  final String title;
  final bool isEndTime;
  const ClockBox({super.key, required this.title, required this.isEndTime});

  @override
  State<ClockBox> createState() => _ClockBoxState();
  static ValueNotifier<String?> hourNotifireStrat = ValueNotifier(null);
  static ValueNotifier<String?> minuteNotifireStart = ValueNotifier(null);
  static ValueNotifier<String?> hourNotifireEnd = ValueNotifier(null);
  static ValueNotifier<String?> minuteNotifireEnd = ValueNotifier(null);
}

class _ClockBoxState extends State<ClockBox> {
  bool _isDropdownOpen = false;
  OverlayEntry? _dropdownOverlay;

  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

  void _closeDropdown() {
    _dropdownOverlay?.remove();
    setState(() {
      _isDropdownOpen = false;
    });
  }

  void _openDropdown(BuildContext context) {
    final overlay = Overlay.of(context);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _dropdownOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _closeDropdown,
            child: Container(
              color: Colors.transparent, // لایه شفاف برای تشخیص کلیک
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy + renderBox.size.height + 8,
            width: renderBox.size.width,
            child: Material(
              color: Color(0xff828282).withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
              elevation: 3, // سایه
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // دقیقه
                          _buildTimeColumn(
                            controller: _minuteController,
                            minValue: 0,
                            maxValue: 59,
                            isHour: false,
                          ),

                          SizedBox(width: 30),
                          BigRegular(':'),
                          SizedBox(width: 30),
                          // ساعت
                          _buildTimeColumn(
                            controller: _hourController,
                            minValue: 0,
                            maxValue: 23,
                            isHour: true,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          _closeDropdown();
                        },
                        child: Container(
                          height: 37,
                          decoration: BoxDecoration(
                            color: Color(0xffF1F3F5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 14),
                          child: NormalMedium('ثبت'),
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_dropdownOverlay!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  Widget _buildTimeColumn({
    required TextEditingController controller,
    required int minValue,
    required int maxValue,
    required bool isHour,
  }) {
    String previousValue = controller.text; // مقدار قبلی ذخیره شده

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.keyboard_arrow_up_rounded, color: Color(0xff861C8C)),
          onPressed: () {
            final currentValue = int.tryParse(controller.text) ?? minValue;
            if (currentValue < maxValue) {
              setState(() {
                previousValue = (currentValue + 1).toString().padLeft(2, '0');
                controller.text = previousValue;
                if (widget.isEndTime) {
                  isHour
                      ? ClockBox.hourNotifireEnd.value = controller.text
                      : ClockBox.minuteNotifireEnd.value = controller.text;
                } else {
                  isHour
                      ? ClockBox.hourNotifireStrat.value = controller.text
                      : ClockBox.minuteNotifireStart.value = controller.text;
                }
              });
            }
          },
        ),
        SizedBox(
          width: 40,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontFamily: FontFamily.iRANSansXFAMedium,
              color: Color(0xff540E5C),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TextInputFormatter.withFunction((oldValue, newValue) {
                final text = newValue.text;
                if (text.isEmpty) {
                  return oldValue;
                }
                final value = int.tryParse(text);
                if (value == null || value < minValue || value > maxValue) {
                  return oldValue;
                }
                return newValue;
              }),
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  controller.text = previousValue;

                  if (widget.isEndTime) {
                    isHour
                        ? ClockBox.hourNotifireEnd.value = controller.text
                        : ClockBox.minuteNotifireEnd.value = controller.text;
                  } else {
                    isHour
                        ? ClockBox.hourNotifireStrat.value = controller.text
                        : ClockBox.minuteNotifireStart.value = controller.text;
                  }
                  // تنظیم مکان‌نما به آخر متن
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length),
                  );
                });
              } else {
                previousValue = value;
              }
            },
            // اضافه کردن رویداد onTap برای انتقال مکان‌نما به آخر
            onTap: () {
              setState(() {
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              });
            },
          ),
        ),
        IconButton(
          icon:
              Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xff861C8C)),
          onPressed: () {
            final currentValue = int.tryParse(controller.text) ?? maxValue;
            if (currentValue > minValue) {
              setState(() {
                previousValue = (currentValue - 1).toString().padLeft(2, '0');
                controller.text = previousValue;
                if (widget.isEndTime) {
                  isHour
                      ? ClockBox.hourNotifireEnd.value = controller.text
                      : ClockBox.minuteNotifireEnd.value = controller.text;
                } else {
                  isHour
                      ? ClockBox.hourNotifireStrat.value = controller.text
                      : ClockBox.minuteNotifireStart.value = controller.text;
                }
              });
            }
          },
        ),
      ],
    );
  }

  void _toggleDropdown(BuildContext context) {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      // زمانی که کاربر خارج از متن کلیک کند، فوکوس برداشته می‌شود
      FocusScope.of(context).requestFocus(FocusNode());
      _openDropdown(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isDropdownOpen) {
          _closeDropdown();
          return false;
        }
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalMedium(widget.title),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () => _toggleDropdown(
              context,
            ),
            child: Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isDropdownOpen
                      ? const Color(0xff861C8C)
                      : const Color(0xffE0E0F9),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Assets.icons.circleClock.svg(),
                  SizedBox(width: 8),
                  NormalRegular(
                    '${_hourController.text}:${_minuteController.text}',
                    textColorInLight: Color(0xff540E5C),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
