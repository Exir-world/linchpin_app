// import 'package:flutter/material.dart';
// import 'package:linchpin/core/common/dimens.dart';
// import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
// import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';
// import 'package:linchpin/gen/fonts.gen.dart';

// class FontHelper {
//   static String? _cachedLanguage;

//   static Future<void> loadLanguage() async {
//     PrefService prefService = PrefService();
//     _cachedLanguage =
//         await prefService.readCacheString(SharedKey.selectedLanguage);
//   }

//   static String getFont(String persianFont, String englishFont) {
//     if (_cachedLanguage != null && _cachedLanguage!.startsWith('en')) {
//       return englishFont;
//     } else {
//       return persianFont;
//     }
//   }
// }

// class TextStyles {
//   static TextStyle defaultStyle = TextStyle(
//     fontSize: TEXT_SIZE_VERY_SMALL,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFARegular, FontFamily.productSansRegular),
//     height: TEXT_HEIGHT,
//   );

//   // VERY SMALL
//   static TextStyle verySmallRegular = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_VERY_SMALL,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFARegular, FontFamily.productSansRegular),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle verySmallMedium = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_VERY_SMALL,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFAMedium, FontFamily.productSansMedium),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle verySmallDemiBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_VERY_SMALL,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFADemiBold, FontFamily.productSansDemiBold),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle verySmallBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_VERY_SMALL,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFABold, FontFamily.productSansBold),
//     height: TEXT_HEIGHT,
//   );

//   // SMALL
//   static TextStyle smallRegular = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_SMALL,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFARegular, FontFamily.productSansRegular),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle smallMedium = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_SMALL,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFAMedium, FontFamily.productSansMedium),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle smallDemiBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_SMALL,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFADemiBold, FontFamily.productSansDemiBold),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle smallBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_SMALL,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFABold, FontFamily.productSansBold),
//     height: TEXT_HEIGHT,
//   );

//   // NORMAL
//   static TextStyle normalRegular = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_NORMAL,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFARegular, FontFamily.productSansRegular),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle normalMedium = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_NORMAL,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFAMedium, FontFamily.productSansMedium),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle normalDemiBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_NORMAL,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFADemiBold, FontFamily.productSansDemiBold),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle normalBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_NORMAL,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFABold, FontFamily.productSansBold),
//     height: TEXT_HEIGHT,
//   );

//   // LARGE
//   static TextStyle largeRegular = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_LARGE,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFARegular, FontFamily.productSansRegular),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle largeMedium = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_LARGE,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFAMedium, FontFamily.productSansMedium),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle largeDemiBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_LARGE,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFADemiBold, FontFamily.productSansDemiBold),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle largeBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_LARGE,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFABold, FontFamily.productSansBold),
//     height: TEXT_HEIGHT,
//   );

//   // BIG
//   static TextStyle bigRegular = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_BIG,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFARegular, FontFamily.productSansRegular),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle bigMedium = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_BIG,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFAMedium, FontFamily.productSansMedium),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle bigDemiBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_BIG,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFADemiBold, FontFamily.productSansDemiBold),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle bigBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_BIG,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFABold, FontFamily.productSansBold),
//     height: TEXT_HEIGHT,
//   );

//   // Very BIG
//   static TextStyle veryBigRegular = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_VERY_BIG,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFARegular, FontFamily.productSansRegular),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle veryBigMedium = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_VERY_BIG,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFAMedium, FontFamily.productSansMedium),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle veryBigDemiBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_VERY_BIG,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFADemiBold, FontFamily.productSansDemiBold),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle veryBigBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_VERY_BIG,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFABold, FontFamily.productSansBold),
//     height: TEXT_HEIGHT,
//   );

//   // HUGE
//   static TextStyle hugeRegular = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_HUGE,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFARegular, FontFamily.productSansRegular),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle hugeMedium = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_HUGE,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFAMedium, FontFamily.productSansMedium),
//     height: TEXT_HEIGHT,
//   );
//   static TextStyle hugeDemiBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_HUGE,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFADemiBold, FontFamily.productSansDemiBold),
//     height: TEXT_HEIGHT,
//   );
//   static TextStyle hugeBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_HUGE,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFABold, FontFamily.productSansBold),
//     height: TEXT_HEIGHT,
//   );

//   // VERY HUGE
//   static TextStyle veryHugeRegular = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_VERY_HUGE,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFARegular, FontFamily.productSansRegular),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle veryHugeMedium = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_VERY_HUGE,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFAMedium, FontFamily.productSansMedium),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle veryHugeDemiBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_VERY_HUGE,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFADemiBold, FontFamily.productSansDemiBold),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle veryHugeBold = defaultStyle.copyWith(
//     fontSize: TEXT_SIZE_VERY_HUGE,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFABold, FontFamily.productSansBold),
//     height: TEXT_HEIGHT,
//   );

//   // MEGA
//   static TextStyle megaRegular = defaultStyle.copyWith(
//     fontSize: 54,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFARegular, FontFamily.productSansRegular),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle megaMedium = defaultStyle.copyWith(
//     fontSize: 54,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFAMedium, FontFamily.productSansMedium),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle megaDemiBold = defaultStyle.copyWith(
//     fontSize: 54,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFADemiBold, FontFamily.productSansDemiBold),
//     height: TEXT_HEIGHT,
//   );

//   static TextStyle megaBold = defaultStyle.copyWith(
//     fontSize: 54,
//     fontFamily: FontHelper.getFont(
//         FontFamily.iRANSansXFABold, FontFamily.productSansBold),
//     height: TEXT_HEIGHT,
//   );
// }
