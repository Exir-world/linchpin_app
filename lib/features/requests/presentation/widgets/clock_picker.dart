import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Linchpin/core/common/text_widgets.dart';
import 'package:Linchpin/gen/fonts.gen.dart';

class ClockPicker {
  static Future<TimeOfDay?> show(
    BuildContext context, {
    required TimeOfDay? initialTime,
    void Function(TimeOfDay)? onCompleted, // تغییر به onCompleted
  }) async {
    return showDialog<TimeOfDay>(
      context: context,
      builder: (context) {
        return _ClockPickerDialog(
            initialTime: initialTime, onCompleted: onCompleted);
      },
    );
  }
}

class _ClockPickerDialog extends StatefulWidget {
  final TimeOfDay? initialTime;
  final void Function(TimeOfDay)? onCompleted;

  const _ClockPickerDialog({required this.initialTime, this.onCompleted});

  @override
  State<_ClockPickerDialog> createState() => _ClockPickerDialogState();
}

class _ClockPickerDialogState extends State<_ClockPickerDialog> {
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();
  String? errorText;

  @override
  void initState() {
    super.initState();
    if (widget.initialTime != null) {
      hourController.text = widget.initialTime!.hour.toString().padLeft(2, '0');
      minuteController.text =
          widget.initialTime!.minute.toString().padLeft(2, '0');
    }
  }

  void _submitTime() {
    if (hourController.text.isEmpty || minuteController.text.isEmpty) return;

    int? hour = int.tryParse(hourController.text);
    int? minute = int.tryParse(minuteController.text);

    if (hour == null || hour < 0 || hour > 23) {
      setState(() => errorText = "ساعت باید بین 00 و 23 باشد");
      return;
    }

    if (minute == null || minute < 0 || minute > 59) {
      setState(() => errorText = "دقیقه باید بین 00 و 59 باشد");
      return;
    }

    setState(() => errorText = null); // خطا برطرف شد

    TimeOfDay selectedTime = TimeOfDay(hour: hour, minute: minute);
    widget.onCompleted?.call(selectedTime);

    Navigator.pop(context, selectedTime);
  }

  void _incrementHour() {
    if (hourController.text.isNotEmpty) {
      int hour = (int.parse(hourController.text) + 1) % 24;
      hourController.text = hour.toString().padLeft(2, '0');
    } else {
      int hour = (0 + 1) % 24;
      hourController.text = hour.toString().padLeft(2, '0');
    }
  }

  void _decrementHour() {
    if (hourController.text.isNotEmpty) {
      int hour = (int.parse(hourController.text) - 1 + 24) % 24;
      hourController.text = hour.toString().padLeft(2, '0');
    } else {
      int hour = (0 - 1 + 24) % 24;
      hourController.text = hour.toString().padLeft(2, '0');
    }
  }

  void _incrementMinute() {
    if (minuteController.text.isNotEmpty) {
      int minute = (int.parse(minuteController.text) + 1) % 60;
      minuteController.text = minute.toString().padLeft(2, '0');
    } else {
      int minute = (0 + 1) % 60;
      minuteController.text = minute.toString().padLeft(2, '0');
    }
  }

  void _decrementMinute() {
    if (minuteController.text.isNotEmpty) {
      int minute = (int.parse(minuteController.text) - 1 + 60) % 60;
      minuteController.text = minute.toString().padLeft(2, '0');
    } else {
      int minute = (0 - 1 + 60) % 60;
      minuteController.text = minute.toString().padLeft(2, '0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SmallRegular(
                  errorText!,
                  textColorInLight: Colors.red,
                ),
              ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeColumn(
                    hourController, _incrementHour, _decrementHour),
                SizedBox(width: 30),
                Text(":",
                    style: TextStyle(fontSize: 24, color: Color(0xff540E5C))),
                SizedBox(width: 30),
                _buildTimeColumn(
                    minuteController, _incrementMinute, _decrementMinute),
              ],
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _submitTime,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xff861C8C),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: NormalMedium("ثبت", textColorInLight: Colors.white),
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(TextEditingController controller,
      VoidCallback onIncrease, VoidCallback onDecrease) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.keyboard_arrow_up_rounded, color: Color(0xff861C8C)),
          onPressed: onIncrease,
        ),
        SizedBox(
          width: 50,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontFamily: FontFamily.iRANSansXFAMedium,
              fontSize: 18,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            decoration: InputDecoration(
              hintText: controller.text.isEmpty ? '00' : null,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            ),
          ),
        ),
        IconButton(
          icon:
              Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xff861C8C)),
          onPressed: onDecrease,
        ),
      ],
    );
  }
}
