import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linchpin/core/common/text_widgets.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/gen/fonts.gen.dart';

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
        NormalMedium(LocaleKeys.explanation.tr()),
        SizedBox(height: 12),
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
                color: Color(0xffE0E0F9),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _controller,
              maxLines: null,
              minLines: 5, // حداقل یک خط ارتفاع
              focusNode: _focusNode,
              style: TextStyle(
                fontFamily: FontFamily.iRANSansXFARegular,
                fontSize: 12,
              ),
              onChanged: (value) {
                ExplanationWidget.explanationNotifire.value = value;
              },
              decoration: InputDecoration(
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
