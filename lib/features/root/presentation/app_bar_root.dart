import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/colors.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin_app/core/shared_preferences/shared_preferences_service.dart';
import 'package:linchpin_app/features/auth/presentation/auth_screen.dart';
import 'package:linchpin_app/features/requests/presentation/requests_screen.dart';
import 'package:linchpin_app/features/root/presentation/root_screen.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

PreferredSize appBarRoot(BuildContext context, bool isRequestScreen) {
  return PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color:
                Color(0xff828282).withValues(alpha: 0.15), // میزان تیرگی سایه
            blurRadius: 100, // میزان محوشدگی سایه
            spreadRadius: 0, // میزان گسترش سایه
            offset: Offset(0, -8), // جهت سایه (افقی، عمودی)
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: BACKGROUND_LIGHT_APP_BAR_COLOR,
        forceMaterialTransparency: false,
        surfaceTintColor: Colors.transparent,
        leading: isRequestScreen
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Color(0xff861C8C),
                  size: 26,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        title: ValueListenableBuilder(
          valueListenable: RootScreen.timeServerNotofire,
          builder: (context, timeServer, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                !isRequestScreen
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestsScreen(),
                              ));
                        },
                        child: Container(
                            color: Colors.transparent,
                            height: kToolbarHeight,
                            padding: EdgeInsets.only(left: 12),
                            child: Assets.icons.docs.svg(height: 26)),
                      )
                    : SizedBox.shrink(),
                ValueListenableBuilder(
                  valueListenable: RootScreen.timeServerNotofire,
                  builder: (context, value, child) {
                    return NormalMedium(value ?? '');
                  },
                ),
                GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true, // to full height
                        useSafeArea: true, // to show under status bar
                        backgroundColor: Colors
                            .transparent, // to show BorderRadius of Container
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
                                        color: Color(0xff000000)
                                            .withValues(alpha: .15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 32),
                                  Row(
                                    children: [
                                      Container(
                                        height: 64,
                                        width: 64,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Assets.icons.avatar.svg(),
                                      ),
                                      SizedBox(width: 16),
                                      Column(
                                        children: [
                                          LargeDemiBold('فرهاد رضوانی'),
                                          SizedBox(height: 8),
                                          NormalMedium('۰۹۳۶۱۲۳۴۵۸۶'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 48),
                                  _ItemProfile(
                                    image: Assets.icons.notification
                                        .svg(height: 24),
                                    title: 'اعلانات',
                                  ),
                                  SizedBox(height: 24),
                                  _ItemProfile(
                                    image: Assets.icons.wallet.svg(height: 24),
                                    title: 'گزارشات مالی',
                                  ),
                                  SizedBox(height: 24),
                                  _ItemProfile(
                                    image:
                                        Assets.icons.calendar.svg(height: 24),
                                    title: 'محاسبه حقوق',
                                  ),
                                  SizedBox(height: 24),
                                  _ItemProfile(
                                    image: Assets.icons.star.svg(height: 24),
                                    title: 'امتیازات',
                                  ),
                                  SizedBox(height: 24),
                                  _ItemProfile(
                                    image: Assets.icons.setting.svg(height: 24),
                                    title: 'تنظیمات برنامه',
                                  ),
                                  SizedBox(height: 24),
                                  Divider(color: Colors.grey.shade100),
                                  SizedBox(height: 24),
                                  _ItemProfile(
                                    image:
                                        Assets.icons.question.svg(height: 24),
                                    title: 'سوالات متداول',
                                  ),
                                  SizedBox(height: 24),
                                  _ItemProfile(
                                    image: Assets.icons.scale.svg(height: 24),
                                    title: 'قوانین',
                                  ),
                                  SizedBox(height: 24),
                                  _ItemProfile(
                                    image: Assets.icons.code.svg(height: 24),
                                    title: 'تغییرات آپدیت ها',
                                  ),
                                  // SizedBox(height: 24),
                                  SizedBox(height: 24),
                                  Divider(color: Colors.grey.shade100),
                                  SizedBox(height: 24),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog<TimeOfDay>(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            backgroundColor: Colors.white,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 24,
                                                horizontal: 24,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  NormalMedium(
                                                    'می‌خواهید از حساب خود خارج شوید؟',
                                                  ),
                                                  SizedBox(height: 24),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            PrefService
                                                                prefService =
                                                                PrefService();
                                                            prefService
                                                                .readCacheString(
                                                                    SharedKey
                                                                        .jwtToken)
                                                                .then(
                                                              (value) {
                                                                prefService
                                                                    .removeCache(
                                                                        SharedKey
                                                                            .expires);
                                                                prefService
                                                                    .removeCache(
                                                                        SharedKey
                                                                            .refreshToken);
                                                                prefService
                                                                    .removeCache(
                                                                        value);
                                                                Navigator.of(
                                                                        context)
                                                                    .pushAndRemoveUntil(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            AuthScreen(),
                                                                  ),
                                                                  (Route<dynamic>
                                                                          route) =>
                                                                      false,
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            height: 44,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xff861C8C),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: NormalMedium(
                                                              'بله',
                                                              textColorInLight:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 24),
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            height: 44,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xffCAC4CF),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: NormalMedium(
                                                                'خیر',
                                                                textColorInLight:
                                                                    Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Assets.icons.logout.svg(height: 22),
                                        SizedBox(width: 8),
                                        NormalMedium(
                                          'خروج از حساب',
                                          textColorInLight: Color(0xffD80B0F),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 32),
                                  Align(
                                    alignment: Alignment.center,
                                    child: SmallMedium(
                                      'Verson 2.00',
                                      textColorInLight: Color(0xffCAC4CF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                        color: Colors.transparent,
                        height: kToolbarHeight,
                        padding: EdgeInsets.only(right: 12),
                        child: Assets.icons.user.svg(height: 26))),
              ],
            );
          },
        ),
      ),
    ),
  );
}

class _ItemProfile extends StatelessWidget {
  final Widget image;
  final String title;
  const _ItemProfile({
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        image,
        SizedBox(width: 8),
        NormalMedium(title),
        Spacer(),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: Color(0xffDADADA),
          size: 16,
        ),
      ],
    );
  }
}

class IOSModalStyle extends StatelessWidget {
  final Widget childBody;

  const IOSModalStyle({
    super.key,
    required this.childBody,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // color of card
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            width: double.infinity,
            child: childBody,
          )
        ],
      ),
    );
  }
}
