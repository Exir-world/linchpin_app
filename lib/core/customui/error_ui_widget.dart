import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linchpin/core/common/text_widgets.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/core/translate/locale_keys.dart';

class ErrorUiWidget extends StatelessWidget {
  final String title;
  final Function() onTap;
  const ErrorUiWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      height: context.screenHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SmallMedium(title),
            SizedBox(height: 24),
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(0xff540E5C),
                ),
                alignment: Alignment.center,
                child: LargeMedium(
                  LocaleKeys.tryAgain.tr(),
                  textColorInLight: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
