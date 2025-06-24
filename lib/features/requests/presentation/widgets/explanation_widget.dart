import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/gen/fonts.gen.dart';

class ExplanationWidget extends StatefulWidget {
  const ExplanationWidget({super.key});

  @override
  State<ExplanationWidget> createState() => _ExplanationWidgetState();
  static ValueNotifier<String?> explanationNotifire = ValueNotifier(null);
}

class _ExplanationWidgetState extends State<ExplanationWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  void _unfocusTextField() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus(); // خارج کردن TextField از حالت فوکوس
    }
  }

  @override
  void initState() {
    ExplanationWidget.explanationNotifire.value = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NormalMedium('توضیح'),
        const SizedBox(height: 12),
        WillPopScope(
          onWillPop: () async {
            if (_focusNode.hasFocus) {
              _unfocusTextField(); // خارج کردن فوکوس هنگام فشار دادن دکمه برگشت
              return false; // جلوگیری از بستن صفحه
            }
            return true; // اجازه به بستن صفحه
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xffE0E0F9),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _controller,
              maxLines: null,
              minLines: 5, // حداقل یک خط ارتفاع
              focusNode: _focusNode,
              style: const TextStyle(
                fontFamily: FontFamily.iRANSansXFARegular,
                fontSize: 12,
              ),
              onChanged: (value) {
                ExplanationWidget.explanationNotifire.value = value;
              },
              decoration: const InputDecoration(
                isCollapsed: true, // حذف فاصله اضافی داخلی
                border: InputBorder.none, // حذف حاشیه پیش‌فرض TextField
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
