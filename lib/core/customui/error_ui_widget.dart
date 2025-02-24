import 'package:flutter/material.dart';
import 'package:Linchpin/core/common/text_widgets.dart';
import 'package:Linchpin/core/extension/context_extension.dart';

class ErrorUiWidget extends StatelessWidget {
  final String title;
  const ErrorUiWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      height: context.screenHeight,
      child: Center(child: SmallRegular(title)),
    );
  }
}
