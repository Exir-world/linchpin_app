import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/box_request_type.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/clock_picker.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class ClockPickerExample extends StatefulWidget {
  final String title;
  final void Function(TimeOfDay) onChange;
  const ClockPickerExample(
      {super.key, required this.title, required this.onChange});

  @override
  State<StatefulWidget> createState() => _ClockPickerExampleState();
}

class _ClockPickerExampleState extends State<ClockPickerExample> {
  TimeOfDay? selectedTime;
  @override
  void initState() {
    BoxRequestType.selectedItemNotifire.addListener(
      () {
        selectedTime = null;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalMedium(widget.title),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              TimeOfDay? time = await ClockPicker.show(
                context,
                initialTime: null,
                onCompleted: (TimeOfDay time) {
                  // ارسال مقدار جدید به بیرون
                  widget.onChange.call(time);
                },
              );

              if (time != null) {
                Future.delayed(Duration.zero, () {
                  setState(() {
                    selectedTime = time;
                  });
                });
              }
            },
            child: Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xffE0E0F9),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Assets.icons.circleClock.svg(),
                  SizedBox(width: 8),
                  NormalRegular(
                    selectedTime != null
                        ? "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}"
                        : "--:--",
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
