// ignore_for_file: no_self_assignments

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linchpin/core/common/colors.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/common/empty_container.dart';
import 'package:linchpin/core/extension/context_extension.dart';

class ProgressButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isEnabled;
  final bool isLoading;
  final Widget? widget;
  final Widget? widgetText;
  final double? width;
  final double? height;
  final Color? btnColor;
  final Color? textColor;
  final List<BoxShadow>? boxShadow;

  const ProgressButton({
    required this.label,
    required this.onTap,
    super.key,
    this.widget,
    this.widgetText,
    this.isEnabled = true,
    this.isLoading = false,
    this.width,
    this.height,
    this.btnColor,
    this.textColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Colors.grey;
    if (isLoading) {
      buttonColor = CupertinoColors.systemGrey3;
    } else if (isEnabled) {
      // buttonColor = BUTTON_BACKGROUND_COLOR;
      buttonColor = btnColor ?? BUTTON_COLOR;
    } else {
      buttonColor = CupertinoColors.inactiveGray.withAlpha(50);
    }

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: width ?? context.screenWidth * 0.64, //! 232px
        height: height ?? context.screenHeight * 0.075, //! 48px
        alignment: Alignment.center,

        decoration: BoxDecoration(
          boxShadow: boxShadow,
          borderRadius: BorderRadius.circular(16),
          color: buttonColor,
        ),
        child: isLoading
            //! جلوگیری از repaint شدن کل ویجت ها
            ? const RepaintBoundary(
                child: CupertinoActivityIndicator(
                  color: CupertinoColors.systemGreen,
                ),
              )
            : Row(
                mainAxisAlignment: widget != null
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                children: [
                  widgetText ??
                      NormalBold(
                        label,
                        textColorInLight: !isEnabled && textColor == null
                            ? CupertinoColors.label
                            : textColor ??
                                CupertinoColors.tertiarySystemBackground,
                        textColorInDark: !isEnabled && textColor == null
                            ? CupertinoColors.tertiarySystemBackground
                            : textColor ?? CupertinoColors.systemGrey6,
                      ),
                  widget ?? const EmptyContainer(),
                ],
              ),
      ),
    );
  }
}
