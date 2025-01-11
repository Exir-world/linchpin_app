import 'package:flutter/material.dart';
import 'package:linchpin_app/core/extension/context_extension.dart';

abstract class BaseIconWidget extends StatelessWidget {
  final IconData iconData;
  final Color? iconColorInDark;
  final Color? iconColorInLight;

  const BaseIconWidget(
    this.iconData, {
    this.iconColorInDark,
    this.iconColorInLight,
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
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      size: 24,
      color: getIconColor(context),
    );
  }
}

/// BIG ICON
class BigIcon extends BaseIconWidget {
  const BigIcon(
    super.iconData, {
    super.key,
    super.iconColorInDark,
    super.iconColorInLight,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      size: 30,
      color: getIconColor(context),
    );
  }
}
