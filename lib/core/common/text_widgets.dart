import 'package:flutter/material.dart';
import 'package:Linchpin/core/common/colors.dart';
import 'package:Linchpin/core/common/text_styles.dart';
import 'package:Linchpin/core/extension/context_extension.dart';

abstract class BaseTextWidget extends StatelessWidget {
  final String data;
  final Color? textColorInDark;
  final Color? textColorInLight;
  final int? maxLines;
  final TextDecoration? decoration;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final double? height;

  const BaseTextWidget(
    this.data, {
    this.textColorInDark,
    this.textColorInLight,
    this.maxLines,
    this.decoration,
    super.key,
    this.textAlign,
    this.overflow,
    this.height,
  });

  Color getTextColor(BuildContext context) {
    return context.isDarkBrightness
        ? textColorInDark ?? Colors.white
        : textColorInLight ?? TEXT_LIGHT_COLOR;
  }

  @override
  Widget build(BuildContext context) {
    return Text(data);
  }
}

/// VERY SMALL
class VerySmallRegular extends BaseTextWidget {
  const VerySmallRegular(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.verySmallRegular.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class VerySmallMedium extends BaseTextWidget {
  const VerySmallMedium(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.verySmallMedium.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class VerySmallDemiBold extends BaseTextWidget {
  const VerySmallDemiBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.verySmallDemiBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class VerySmallBold extends BaseTextWidget {
  const VerySmallBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.verySmallBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

/// SMALL
class SmallRegular extends BaseTextWidget {
  const SmallRegular(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.smallRegular.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class SmallMedium extends BaseTextWidget {
  const SmallMedium(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.smallMedium.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class SmallDemiBold extends BaseTextWidget {
  const SmallDemiBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.smallDemiBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class SmallBold extends BaseTextWidget {
  const SmallBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.smallBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

/// NORMAL
class NormalRegular extends BaseTextWidget {
  const NormalRegular(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.normalRegular.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class NormalMedium extends BaseTextWidget {
  const NormalMedium(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.normalMedium.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class NormalDemiBold extends BaseTextWidget {
  const NormalDemiBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.normalDemiBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class NormalBold extends BaseTextWidget {
  const NormalBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.normalBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

/// LARGE
class LargeRegular extends BaseTextWidget {
  const LargeRegular(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.largeRegular.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class LargeMedium extends BaseTextWidget {
  const LargeMedium(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.largeMedium.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class LargeDemiBold extends BaseTextWidget {
  const LargeDemiBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.largeDemiBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class LargeBold extends BaseTextWidget {
  const LargeBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.largeBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

/// BIG
class BigRegular extends BaseTextWidget {
  const BigRegular(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.bigRegular.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class BigMedium extends BaseTextWidget {
  const BigMedium(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.bigMedium.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class BigDemiBold extends BaseTextWidget {
  const BigDemiBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.bigDemiBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class BigBold extends BaseTextWidget {
  const BigBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.bigBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

/// VERY BIG
class VeryBigRegular extends BaseTextWidget {
  const VeryBigRegular(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.veryBigRegular.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class VeryBigMedium extends BaseTextWidget {
  const VeryBigMedium(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.veryBigMedium.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class VeryBigDemiBold extends BaseTextWidget {
  const VeryBigDemiBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.veryBigDemiBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class VeryBigBold extends BaseTextWidget {
  const VeryBigBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.veryBigBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

/// HUGE
class HugeRegular extends BaseTextWidget {
  const HugeRegular(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.hugeRegular.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class HugeMedium extends BaseTextWidget {
  const HugeMedium(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.hugeMedium.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class HugeDemiBold extends BaseTextWidget {
  const HugeDemiBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.hugeDemiBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class HugeBold extends BaseTextWidget {
  const HugeBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.hugeBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

/// VERY HUGE
class VeryHugeRegular extends BaseTextWidget {
  const VeryHugeRegular(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.veryHugeRegular.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class VeryHugeMedium extends BaseTextWidget {
  const VeryHugeMedium(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.veryHugeMedium.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class VeryHugeDemiBold extends BaseTextWidget {
  const VeryHugeDemiBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.veryHugeDemiBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class VeryHugeBold extends BaseTextWidget {
  const VeryHugeBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.veryHugeBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

/// MEGA
class MegaRegular extends BaseTextWidget {
  const MegaRegular(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.megaRegular.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class MegaMedium extends BaseTextWidget {
  const MegaMedium(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.megaMedium.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class MegaDemiBold extends BaseTextWidget {
  const MegaDemiBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.megaDemiBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}

class MegaBold extends BaseTextWidget {
  const MegaBold(
    super.data, {
    super.key,
    super.textColorInDark,
    super.textColorInLight,
    super.maxLines,
    super.decoration,
    super.textAlign,
    super.overflow,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyles.megaBold.copyWith(
        color: getTextColor(context),
        decoration: decoration,
        overflow: overflow,
        height: height,
      ),
    );
  }
}
