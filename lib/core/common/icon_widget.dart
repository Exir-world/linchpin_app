import 'package:flutter/material.dart';
import 'package:linchpin_app/core/extension/context_extension.dart';

abstract class BaseIconWidget extends StatelessWidget {
  final IconData iconData;
  final Color? iconColorInDark;
  final Color? iconColorInLight;
  final double size;

  const BaseIconWidget(
    this.iconData, {
    this.iconColorInDark,
    this.iconColorInLight,
    this.size = 24.0,
    super.key,
  });

  Color getIconColor(BuildContext context) {
    return context.isDarkBrightness
        ? iconColorInDark ?? Colors.white
        : iconColorInLight ?? Color(0xff861C8C);
  }

  @override
  Widget build(BuildContext context) {
    return Icon(iconData);
  }
}

/// NORMAL ICON
class NormalIcon extends BaseIconWidget {
  const NormalIcon(
    super.iconData, {
    super.key,
    super.iconColorInDark,
    super.iconColorInLight,
    super.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      size: size,
      color: getIconColor(context),
    );
  }
}
