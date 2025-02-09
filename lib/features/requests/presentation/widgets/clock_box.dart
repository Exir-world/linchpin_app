// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:linchpin_app/core/common/text_widgets.dart';
// import 'package:linchpin_app/gen/assets.gen.dart';
// import 'package:linchpin_app/gen/fonts.gen.dart';

// class ClockBox extends StatefulWidget {
//   final String title;
//   final bool isEndTime;
//   final Function? onTimeChanged; // اضافه کردن onTimeChanged

//   const ClockBox(
//       {super.key,
//       required this.title,
//       required this.isEndTime,
//       this.onTimeChanged});

//   @override
//   State<ClockBox> createState() => ClockBoxState();

//   // ValueNotifier جدا برای ساعت و دقیقه‌ی هر ClockBox
//   static final ValueNotifier<String?> hourNotifireStart = ValueNotifier(null);
//   static final ValueNotifier<String?> minuteNotifireStart = ValueNotifier(null);
//   static final ValueNotifier<String?> hourNotifireEnd = ValueNotifier(null);
//   static final ValueNotifier<String?> minuteNotifireEnd = ValueNotifier(null);
// }

// class ClockBoxState extends State<ClockBox> {
//   late ValueNotifier<String?> hourNotifier;
//   late ValueNotifier<String?> minuteNotifier;
//   late TextEditingController hourController;
//   late TextEditingController minuteController;
//   late FocusNode _hourFocusNode;
//   late FocusNode _minuteFocusNode;
//   bool _isDropdownOpen = false;
//   OverlayEntry? _dropdownOverlay;

//   @override
//   void initState() {
//     super.initState();

//     if (widget.isEndTime) {
//       hourNotifier = ClockBox.hourNotifireEnd;
//       minuteNotifier = ClockBox.minuteNotifireEnd;
//     } else {
//       hourNotifier = ClockBox.hourNotifireStart;
//       minuteNotifier = ClockBox.minuteNotifireStart;
//     }

//     hourController = TextEditingController(text: hourNotifier.value ?? '');
//     minuteController = TextEditingController(text: minuteNotifier.value ?? '');

//     _hourFocusNode = FocusNode();
//     _minuteFocusNode = FocusNode();

//     _hourFocusNode.addListener(() {
//       if (!_hourFocusNode.hasFocus) {
//         _validateTime(hourController, 23);
//       }
//     });

//     _minuteFocusNode.addListener(() {
//       if (!_minuteFocusNode.hasFocus) {
//         _validateTime(minuteController, 59);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _hourFocusNode.dispose();
//     _minuteFocusNode.dispose();
//     hourController.dispose();
//     minuteController.dispose();
//     super.dispose();
//   }

//   void _validateTime(TextEditingController controller, int maxValue) {
//     if (controller.text.isEmpty || int.tryParse(controller.text) == null) {
//       controller.text = "00";
//     } else {
//       int value = int.parse(controller.text);
//       if (value > maxValue) {
//         controller.text = "00";
//       } else if (controller.text.length == 1) {
//         controller.text = "0${controller.text}";
//       }
//     }
//   }

//   void _onTimeChanged() {
//     hourNotifier.value = hourController.text;
//     minuteNotifier.value = minuteController.text;
//     if (widget.onTimeChanged != null) {
//       widget.onTimeChanged!(); // فراخوانی onTimeChanged از والد
//     }
//   }

//   void _updateEmpty(TextEditingController controller, int maxValue) {
//     if (controller.text.isEmpty) {
//       setState(() {
//         controller.text = "00"; // مقدار پیش‌فرض اگر خالی بود
//       });
//     } else {
//       int? value = int.tryParse(controller.text);
//       if (value == null || value > maxValue) {
//         setState(() {
//           controller.text = "00"; // مقدار نامعتبر را اصلاح کن
//         });
//       } else if (controller.text.length == 1) {
//         setState(() {
//           controller.text = "0${controller.text}"; // مقدار نامعتبر را اصلاح کن
//         });
//       }
//     }
//   }

//   void _closeDropdown() {
//     _updateEmpty(hourController, 23);
//     _updateEmpty(minuteController, 59);
//     _dropdownOverlay?.remove();
//     setState(() {
//       _hourFocusNode;
//       _isDropdownOpen = false;
//     });
//   }

//   void _openDropdown(BuildContext context) {
//     final overlay = Overlay.of(context);
//     final RenderBox renderBox = context.findRenderObject() as RenderBox;
//     final position = renderBox.localToGlobal(Offset.zero);

//     _dropdownOverlay = OverlayEntry(
//       builder: (context) => Stack(
//         children: [
//           GestureDetector(
//             onTap: _closeDropdown,
//             child: Container(
//               color: Colors.transparent, // لایه شفاف برای تشخیص کلیک
//             ),
//           ),
//           Positioned(
//             left: position.dx,
//             top: position.dy + renderBox.size.height + 8,
//             width: renderBox.size.width,
//             child: Material(
//               color: Color(0xff828282).withValues(alpha: 0.04),
//               borderRadius: BorderRadius.circular(8),
//               elevation: 3, // سایه
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(height: 18),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // دقیقه
//                           _buildTimeColumn(
//                             controller: minuteController,
//                             minValue: 0,
//                             maxValue: 59,
//                             isHour: false,
//                           ),

//                           SizedBox(width: 30),
//                           BigRegular(':'),
//                           SizedBox(width: 30),
//                           // ساعت
//                           _buildTimeColumn(
//                             controller: hourController,
//                             minValue: 0,
//                             maxValue: 23,
//                             isHour: true,
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 16),
//                       GestureDetector(
//                         onTap: () {
//                           _closeDropdown();
//                         },
//                         child: Container(
//                           height: 37,
//                           decoration: BoxDecoration(
//                             color: Color(0xffF1F3F5),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           alignment: Alignment.center,
//                           margin: EdgeInsets.symmetric(horizontal: 14),
//                           child: NormalMedium('ثبت'),
//                         ),
//                       ),
//                       SizedBox(height: 12),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

//     overlay.insert(_dropdownOverlay!);
//     setState(() {
//       _isDropdownOpen = true;
//     });
//   }

//   Widget _buildTimeColumn({
//     required TextEditingController controller,
//     required int minValue,
//     required int maxValue,
//     required bool isHour,
//   }) {
//     String previousValue = controller.text; // مقدار قبلی ذخیره شده

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: Icon(Icons.keyboard_arrow_up_rounded, color: Color(0xff861C8C)),
//           onPressed: () {
//             final currentValue = int.tryParse(controller.text) ?? minValue;
//             if (currentValue < maxValue) {
//               setState(() {
//                 previousValue = (currentValue + 1).toString().padLeft(2, '0');
//                 controller.text = previousValue;
//                 if (widget.isEndTime) {
//                   isHour
//                       ? ClockBox.hourNotifireEnd.value = controller.text
//                       : ClockBox.minuteNotifireEnd.value = controller.text;
//                 } else {
//                   isHour
//                       ? ClockBox.hourNotifireStart.value = controller.text
//                       : ClockBox.minuteNotifireStart.value = controller.text;
//                 }
//               });
//             }
//           },
//         ),
//         SizedBox(
//           width: 80,
//           child: TextField(
//             controller: controller,
//             focusNode: isHour ? _hourFocusNode : _minuteFocusNode,
//             textAlign: TextAlign.center,
//             keyboardType: TextInputType.number,
//             style: TextStyle(
//               fontFamily: FontFamily.iRANSansXFAMedium,
//               color: Color(0xff540E5C),
//             ),
//             inputFormatters: [
//               FilteringTextInputFormatter.digitsOnly,
//               LengthLimitingTextInputFormatter(2), // محدود کردن به 2 رقم
//             ],
//             decoration: InputDecoration(
//               hintText: '00',
//               hintStyle: TextStyle(
//                 color: Color(0xffCAC4CF),
//               ),
//               border: InputBorder.none,
//               isDense: true,
//               contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//             ),
//             onChanged: (value) => _onTimeChanged(),
//             onEditingComplete: () {
//               setState(() {
//                 if (controller.text.isEmpty) {
//                   controller.text = "00"; // مقدار پیش‌فرض وقتی فوکوس از بین رفت
//                 } else if (controller.text.length == 1) {
//                   controller.text = "0${controller.text}";
//                 }
//               });
//             },
//             onTap: () {
//               setState(() {
//                 controller.selection = TextSelection.fromPosition(
//                   TextPosition(offset: controller.text.length),
//                 );
//               });
//             },
//           ),
//         ),
//         IconButton(
//           icon:
//               Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xff861C8C)),
//           onPressed: () {
//             final currentValue = int.tryParse(controller.text) ?? maxValue;
//             if (currentValue > minValue) {
//               setState(() {
//                 previousValue = (currentValue - 1).toString().padLeft(2, '0');
//                 controller.text = previousValue;

//                 // مقدار مربوط به این نمونه را از Map بگیریم و مقدار جدید را در آن قرار دهیم
//                 if (widget.isEndTime) {
//                   isHour
//                       ? ClockBox.hourNotifireEnd.value = controller.text
//                       : ClockBox.minuteNotifireEnd.value = controller.text;
//                 } else {
//                   isHour
//                       ? ClockBox.hourNotifireStart.value = controller.text
//                       : ClockBox.minuteNotifireStart.value = controller.text;
//                 }
//               });
//             }
//           },
//         ),
//       ],
//     );
//   }

//   void _toggleDropdown(BuildContext context) {
//     if (_isDropdownOpen) {
//       _closeDropdown();
//     } else {
//       FocusScope.of(context).requestFocus(FocusNode());
//       _openDropdown(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_isDropdownOpen) {
//           _closeDropdown();
//           return false;
//         }
//         return true;
//       },
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           NormalMedium(widget.title),
//           SizedBox(height: 12),
//           GestureDetector(
//             onTap: () => _toggleDropdown(context),
//             child: Container(
//               width: double.infinity,
//               height: 50,
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: _isDropdownOpen
//                       ? const Color(0xff861C8C)
//                       : const Color(0xffE0E0F9),
//                 ),
//               ),
//               alignment: Alignment.centerLeft,
//               child: Row(
//                 children: [
//                   Assets.icons.circleClock.svg(),
//                   SizedBox(width: 8),
//                   NormalRegular(
//                     hourController.value.text.isEmpty &&
//                             minuteController.value.text.isEmpty
//                         ? '--:--'
//                         : '${hourController.value.text}:${minuteController.value.text}',
//                     textColorInLight: hourController.value.text.isEmpty &&
//                             minuteController.value.text.isEmpty
//                         ? Color(0xffCAC4CF)
//                         : Color(0xff540E5C),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
