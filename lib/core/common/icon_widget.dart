import 'package:flutter/material.dart';
import 'package:linchpin/core/common/colors.dart';
import 'package:linchpin/core/common/dimens.dart';
import 'package:linchpin/core/extension/context_extension.dart';

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
        : iconColorInLight ?? ICON_COLOR;
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
      size: ICON_SIZE_NORMAL,
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
      size: ICON_SIZE_BIG,
      color: getIconColor(context),
    );
  }
}
