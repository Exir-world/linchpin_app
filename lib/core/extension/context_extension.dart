import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  bool get isDarkBrightness => Theme.of(this).brightness == Brightness.dark;

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
}
