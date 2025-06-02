import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/growth/presentation/bloc/growth_bloc.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';
import 'package:linchpin/features/root/presentation/root_screen.dart';
import 'package:shamsi_date/shamsi_date.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? languageApp;
  void formatDateTime(BuildContext context, DateTime dateTime) {
    if (languageApp == 'en') {
      // لیست نام ماه‌های میلادی به انگلیسی
      List<String> englishMonths = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
      ];

      // دریافت نام ماه از لیست
      String monthName = englishMonths[dateTime.month - 1];

      // ایجاد فرمت تاریخ مانند "15 March"
      String formattedDate = '${dateTime.day} $monthName';
      RootScreen.timeServerNotofire.value = formattedDate;
    } else if (languageApp == 'ar') {
      // لیست نام ماه‌های میلادی به عربی
      List<String> arabicMonths = [
        "يناير",
        "فبراير",
        "مارس",
        "أبريل",
        "مايو",
        "يونيو",
        "يوليو",
        "أغسطس",
        "سبتمبر",
        "أكتوبر",
        "نوفمبر",
        "ديسمبر"
      ];

      // دریافت نام ماه از لیست
      String monthName = arabicMonths[dateTime.month - 1];

      // ایجاد فرمت تاریخ مانند "25 مارس"
      String formattedDate = '${dateTime.day} $monthName';
      RootScreen.timeServerNotofire.value = formattedDate;
    } else {
      // تبدیل تاریخ میلادی به تاریخ شمسی
      Jalali shamsiDate = Jalali.fromDateTime(dateTime);

      // فرمت تاریخ شمسی به صورت "روز نام ماه" (مثلاً: ۲۲ دی)
      String formattedDate = '${shamsiDate.day} ${shamsiDate.formatter.mN}';
      RootScreen.timeServerNotofire.value = formattedDate;
    }
  }

  Future<void> _saveSelectedLanguageToPrefs(String language) async {
    PrefService prefService = PrefService();
    await prefService.createCacheString(SharedKey.selectedLanguage, language);
  }

  void _onLanguageSelected(String language) async {
    await _saveSelectedLanguageToPrefs(language);
    if (!mounted) return;
    formatDateTime(context, DateTime.now());
    if (mounted) {
      context.setLocale(Locale(language));
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    languageApp = EasyLocalization.of(context)?.locale.languageCode;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        BlocProvider.of<GrowthBloc>(context).add(UserImprovementEvent());
      },
      child: Scaffold(
        appBar: appBarRoot(
          context,
          true,
          () {
            Navigator.pop(context);
            BlocProvider.of<GrowthBloc>(context).add(UserImprovementEvent());
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              BigDemiBold(LocaleKeys.settings.tr()),
              SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  List<Language> listLanguege = [
                    Language(name: 'فارسی (Persian)', code: 'fa'),
                    Language(name: 'انگلیسی (English)', code: 'en'),
                    Language(name: 'عربی (Arabic)', code: 'ar'),
                  ];
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    backgroundColor: Colors.transparent,
                    sheetAnimationStyle: AnimationStyle(
                      reverseCurve: Curves.easeIn,
                      duration: Duration(milliseconds: 400),
                    ),
                    builder: (context) {
                      return IOSModalStyle(
                          childBody: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 23,
                                height: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color:
                                      Color(0xff000000).withValues(alpha: .15),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            ListView.builder(
                              itemCount: listLanguege.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final data = listLanguege[index];
                                return GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      languageApp = data.code;
                                    });
                                    _onLanguageSelected(data.code);
                                  },
                                  child: Container(
                                    height: 56,
                                    margin: EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: data.code == languageApp
                                              ? Color(0xff861C8C)
                                              : Color(0xffE0E0F9)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      children: [
                                        NormalDemiBold(
                                          data.name,
                                          textColorInLight:
                                              data.code == languageApp
                                                  ? Color(0xff861C8C)
                                                  : Color(0xff4F4F4F),
                                        ),
                                        Spacer(),
                                        data.code == languageApp
                                            ? Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    height: 18,
                                                    width: 18,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffB12EB9),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 8,
                                                    width: 8,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                height: 16,
                                                width: 16,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(0, 0),
                                                      color: Color(0xff030712)
                                                          .withValues(
                                                              alpha: 0.8),
                                                      spreadRadius: 0.1,
                                                    ),
                                                    BoxShadow(
                                                      offset: Offset(0, 1),
                                                      blurRadius: 2,
                                                      color: Color(0xff030712)
                                                          .withValues(
                                                              alpha: 0.12),
                                                      spreadRadius: 0,
                                                    ),
                                                  ],
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ));
                    },
                  );
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      NormalMedium(LocaleKeys.language.tr()),
                      Spacer(),
                      Row(
                        children: [
                          NormalRegular(
                            languageApp == 'fa'
                                ? 'فارسی'
                                : languageApp == 'en'
                                    ? 'English'
                                    : languageApp == 'ar'
                                        ? 'عربي'
                                        : 'فارسی',
                            textColorInLight: Color(0xff88719B),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(0xffDADADA),
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Language {
  final String name;
  final String code;

  Language({required this.name, required this.code});
}
