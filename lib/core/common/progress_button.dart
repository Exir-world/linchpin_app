// ignore_for_file: no_self_assignments

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Colors.grey;
    if (isLoading) {
      buttonColor = CupertinoColors.systemIndigo;
    } else if (isEnabled) {
      // buttonColor = BUTTON_BACKGROUND_COLOR;
      buttonColor = btnColor ?? CupertinoColors.systemOrange;
    } else {
      buttonColor = CupertinoColors.systemPink;
    }

    return Container(
      width: width ?? context.screenWidth * 0.64, //! 232px
      height: height ?? context.screenHeight * 0.075, //! 48px
      alignment: Alignment.center,
      decoration: BoxDecoration(
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
                    NormalRegular(
                      label,
                      textColorInLight: !isEnabled && textColor == null
                          ? CupertinoColors.systemYellow
                          : textColor ??
                              CupertinoColors.tertiarySystemBackground,
                      textColorInDark: !isEnabled && textColor == null
                          ? CupertinoColors.tertiarySystemBackground
                          : textColor ?? CupertinoColors.systemGrey6,
                    ),
                widget ?? const EmptyContainer(),
              ],
            ),
    );
  }
}
