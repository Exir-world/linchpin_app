import 'package:flutter/material.dart';
import 'package:linchpin/core/common/colors.dart';
import 'package:linchpin/core/extension/context_extension.dart';

class ShowText extends StatelessWidget {
  const ShowText({
    super.key,
    this.text,
  });
  final Widget? text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: TEXT_LIGHT_CHRONOMETER_COLOR.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            offset: Offset(0, 3),
            color: Color(0xff828282).withValues(alpha: .05),
          ),
        ],
      ),
      child: text,
    );
  }
}
