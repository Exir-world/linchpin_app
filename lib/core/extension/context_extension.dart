import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  bool get isDarkBrightness => Theme.of(this).brightness == Brightness.dark;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
