import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linchpin/core/common/text_widgets.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/auth/presentation/auth_screen.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveSelectedLanguage(String language) async {
    PrefService prefService = PrefService();
    await prefService.createCacheString(SharedKey.selectedLanguage, language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(context, true),
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
                                color: Color(0xff000000).withValues(alpha: .15),
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
                              return ValueListenableBuilder(
                                valueListenable: AuthScreen.languageNotifire,
                                builder: (context, valueL, child) {
                                  return GestureDetector(
                                    onTap: () async {
                                      AuthScreen.languageNotifire.value =
                                          data.code;
                                      print(
                                          'Language changed to: ${AuthScreen.languageNotifire.value}');
                                      String languageCode;
                                      switch (data.name) {
                                        case 'فارسی (Persian)':
                                          languageCode = data.code;
                                          break;
                                        case 'انگلیسی (English)':
                                          languageCode = data.code;
                                          break;
                                        case 'عربی (Arabic)':
                                          languageCode = data.code;
                                          break;
                                        default:
                                          languageCode = data.code;
                                      }
                                      if (data.name == 'فارسی (Persian)') {
                                        await _saveSelectedLanguage(data.code);
                                      } else if (data.name ==
                                          'انگلیسی (English)') {
                                        await _saveSelectedLanguage(data.code);
                                      } else if (data.name == 'عربی (Arabic)') {
                                        await _saveSelectedLanguage(data.code);
                                      }
                                      if (data.name == 'انگلیسی (English)') {
                                        AuthScreen.languageNotifire.value =
                                            data.code;
                                      } else if (data.name == 'عربی (Arabic)') {
                                        AuthScreen.languageNotifire.value =
                                            data.code;
                                      } else if (data.name ==
                                          'فارسی (Persian)') {
                                        AuthScreen.languageNotifire.value =
                                            data.code;
                                      }

                                      if (mounted) {
                                        context.setLocale(Locale(languageCode));
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 56,
                                      margin: EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: data.code == valueL
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
                                                data.code == valueL
                                                    ? Color(0xff861C8C)
                                                    : Color(0xff4F4F4F),
                                          ),
                                          Spacer(),
                                          data.code == valueL
                                              ? Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      height: 18,
                                                      width: 18,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffB12EB9),
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
                              );
                            },
                          ),
                        ],
                      ),
                    ));
                  },
                );
              },
              child: ValueListenableBuilder(
                valueListenable: AuthScreen.languageNotifire,
                builder: (context, language, child) {
                  return Container(
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
                              language == 'fa'
                                  ? 'فارسی'
                                  : language == 'en'
                                      ? 'English'
                                      : language == 'ar'
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
                  );
                },
              ),
            ),
          ],
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
