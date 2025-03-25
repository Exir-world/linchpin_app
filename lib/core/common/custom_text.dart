import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:linchpin/core/common/dimens.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';
import 'package:linchpin/gen/fonts.gen.dart';

class CustomText extends StatelessWidget {
  final String data;
  final double size;
  final FontWeight weight;
  final Color? textColorInDark;
  final Color? textColorInLight;
  final int? maxLines;
  final TextDecoration? decoration;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final double? height;

  const CustomText(
    this.data, {
    required this.size,
    required this.weight,
    this.textColorInDark,
    this.textColorInLight,
    this.maxLines,
    this.decoration,
    this.textAlign,
    this.overflow,
    this.height,
    super.key,
  });

  Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textColorInDark ?? Colors.white
        : textColorInLight ?? Colors.black;
  }

  String getFontFamily(BuildContext context) {
    PrefService prefService = PrefService();
    bool isEnglish = EasyLocalization.of(context)?.locale.languageCode == 'en';
    String? languageCode = EasyLocalization.of(context)?.locale.languageCode;
    prefService.createCacheString(
        SharedKey.selectedLanguageCode, languageCode ?? '');
    if (weight == FontWeight.w400) {
      return isEnglish
          ? FontFamily.productSansRegular
          : FontFamily.iRANSansXFARegular;
    } else if (weight == FontWeight.w500) {
      return isEnglish
          ? FontFamily.productSansMedium
          : FontFamily.iRANSansXFAMedium;
    } else if (weight == FontWeight.w600) {
      return isEnglish
          ? FontFamily.productSansDemiBold
          : FontFamily.iRANSansXFADemiBold;
    } else {
      return isEnglish
          ? FontFamily.productSansBold
          : FontFamily.iRANSansXFABold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      data.tr(),
      maxLines: maxLines,
      overflow: maxLines == 1 ? TextOverflow.ellipsis : overflow,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        fontFamily: getFontFamily(context),
        color: getTextColor(context),
        decoration: decoration,
        height: height,
      ),
    );
  }
}

// کلاس‌های مشخص برای استفاده بدون نیاز به وارد کردن سایز و وزن

class VerySmallRegular extends CustomText {
  const VerySmallRegular(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_VERY_SMALL,
          weight: FontWeight.w400,
        );
}

class VerySmallMedium extends CustomText {
  const VerySmallMedium(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_VERY_SMALL,
          weight: FontWeight.w500,
        );
}

class VerySmallDemiBold extends CustomText {
  const VerySmallDemiBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_VERY_SMALL,
          weight: FontWeight.w600,
        );
}

class VerySmallBold extends CustomText {
  const VerySmallBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_VERY_SMALL,
          weight: FontWeight.w700,
        );
}

// Small
class SmallRegular extends CustomText {
  const SmallRegular(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_SMALL,
          weight: FontWeight.w400,
        );
}

class SmallMedium extends CustomText {
  const SmallMedium(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_SMALL,
          weight: FontWeight.w500,
        );
}

class SmallDemiBold extends CustomText {
  const SmallDemiBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_SMALL,
          weight: FontWeight.w600,
        );
}

class SmallBold extends CustomText {
  const SmallBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_SMALL,
          weight: FontWeight.w700,
        );
}

// Normal
class NormalRegular extends CustomText {
  const NormalRegular(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_NORMAL,
          weight: FontWeight.w400,
        );
}

class NormalMedium extends CustomText {
  const NormalMedium(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_NORMAL,
          weight: FontWeight.w500,
        );
}

class NormalDemiBold extends CustomText {
  const NormalDemiBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_NORMAL,
          weight: FontWeight.w600,
        );
}

class NormalBold extends CustomText {
  const NormalBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_NORMAL,
          weight: FontWeight.w700,
        );
}

// Large
class LargeRegular extends CustomText {
  const LargeRegular(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_LARGE,
          weight: FontWeight.w400,
        );
}

class LargeMedium extends CustomText {
  const LargeMedium(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_LARGE,
          weight: FontWeight.w500,
        );
}

class LargeDemiBold extends CustomText {
  const LargeDemiBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_LARGE,
          weight: FontWeight.w600,
        );
}

class LargeBold extends CustomText {
  const LargeBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_LARGE,
          weight: FontWeight.w700,
        );
}

// Big
class BigRegular extends CustomText {
  const BigRegular(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_BIG,
          weight: FontWeight.w400,
        );
}

class BigMedium extends CustomText {
  const BigMedium(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_BIG,
          weight: FontWeight.w500,
        );
}

class BigDemiBold extends CustomText {
  const BigDemiBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_BIG,
          weight: FontWeight.w600,
        );
}

class BigBold extends CustomText {
  const BigBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_BIG,
          weight: FontWeight.w700,
        );
}

// Very Big
class VeryBigRegular extends CustomText {
  const VeryBigRegular(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_VERY_BIG,
          weight: FontWeight.w400,
        );
}

class VeryBigMedium extends CustomText {
  const VeryBigMedium(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_VERY_BIG,
          weight: FontWeight.w500,
        );
}

class VeryBigDemiBold extends CustomText {
  const VeryBigDemiBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_VERY_BIG,
          weight: FontWeight.w600,
        );
}

class VeryBigBold extends CustomText {
  const VeryBigBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_VERY_BIG,
          weight: FontWeight.w700,
        );
}

// Huge
class HugeRegular extends CustomText {
  const HugeRegular(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_HUGE,
          weight: FontWeight.w400,
        );
}

class HugeMedium extends CustomText {
  const HugeMedium(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_HUGE,
          weight: FontWeight.w500,
        );
}

class HugeDemiBold extends CustomText {
  const HugeDemiBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_HUGE,
          weight: FontWeight.w600,
        );
}

class HugeBold extends CustomText {
  const HugeBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_HUGE,
          weight: FontWeight.w700,
        );
}

// Very Huge
class VeryHugeRegular extends CustomText {
  const VeryHugeRegular(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_VERY_HUGE,
          weight: FontWeight.w400,
        );
}

class VeryHugeMedium extends CustomText {
  const VeryHugeMedium(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_VERY_HUGE,
          weight: FontWeight.w500,
        );
}

class VeryHugeDemiBold extends CustomText {
  const VeryHugeDemiBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_VERY_HUGE,
          weight: FontWeight.w600,
        );
}

class VeryHugeBold extends CustomText {
  const VeryHugeBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: TEXT_SIZE_VERY_HUGE,
          weight: FontWeight.w700,
        );
}

// Mega
class MegaRegular extends CustomText {
  const MegaRegular(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: 54,
          weight: FontWeight.w400,
        );
}

class MegaMedium extends CustomText {
  const MegaMedium(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: 54,
          weight: FontWeight.w500,
        );
}

class MegaDemiBold extends CustomText {
  const MegaDemiBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: 54,
          weight: FontWeight.w600,
        );
}

class MegaBold extends CustomText {
  const MegaBold(super.data,
      {super.key,
      super.textColorInLight,
      super.textColorInDark,
      super.decoration,
      super.overflow})
      : super(
          size: 54,
          weight: FontWeight.w700,
        );
}
