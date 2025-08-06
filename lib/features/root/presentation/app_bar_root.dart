import 'package:easy_localization/easy_localization.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/laws/laws_screen.dart';
import 'package:linchpin/features/notifications/presentation/notifications_screen.dart';
import 'package:linchpin/features/pay_slip/presentation/pay_slip_screen.dart';
import 'package:linchpin/features/property/presentation/property_screen.dart';
import 'package:linchpin/features/setting/setting_screen.dart';
import 'package:linchpin/features/time_management/presentation/time_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:linchpin/core/common/colors.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';
import 'package:linchpin/features/auth/presentation/pages/auth_screen.dart';
import 'package:linchpin/features/requests/presentation/requests_screen.dart';
import 'package:linchpin/features/root/presentation/root_screen.dart';
import 'package:linchpin/gen/assets.gen.dart';

PreferredSize appBarRoot(
    BuildContext context, bool isRequestScreen, Function()? onPressed) {
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
                onPressed: onPressed,
              )
            : null,
        title: Row(
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
                    backgroundColor:
                        Colors.transparent, // to show BorderRadius of Container
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ValueListenableBuilder(
                                        valueListenable:
                                            TimeManagementScreen.nameNotifire,
                                        builder: (context, value, child) {
                                          return LargeDemiBold(value);
                                        },
                                      ),
                                      SizedBox(height: 8),
                                      ValueListenableBuilder(
                                        valueListenable:
                                            TimeManagementScreen.phoneNotifire,
                                        builder: (context, value, child) {
                                          return NormalMedium(
                                              value.replaceAll("+98", ""));
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 48),
                              _ItemProfile(
                                image:
                                    Assets.icons.notification.svg(height: 24),
                                title: LocaleKeys.notifications.tr(),
                                onTap: () {
                                  navigateToScreen(
                                    context,
                                    NotificationsScreen(),
                                  );
                                },
                              ),
                              SizedBox(height: 24),
                              _ItemProfile(
                                image: Assets.icons.wallet.svg(height: 24),
                                title: LocaleKeys.financialReports.tr(),
                                onTap: () {
                                  navigateToScreen(
                                    context,
                                    PaySlipScreen(),
                                  );
                                },
                              ),
                              SizedBox(height: 24),
                              _ItemProfile(
                                image: Assets.icons.box.svg(height: 24),
                                title: LocaleKeys.propertylist.tr(),
                                onTap: () {
                                  navigateToScreen(
                                    context,
                                    PropertyScreen(),
                                  );
                                },
                              ),
                              SizedBox(height: 24),
                              _ItemProfile(
                                image: Assets.icons.star.svg(height: 24),
                                title: LocaleKeys.privileges.tr(),
                                onTap: () {},
                              ),
                              SizedBox(height: 24),
                              _ItemProfile(
                                image: Assets.icons.setting.svg(height: 24),
                                title: LocaleKeys.appSettings.tr(),
                                onTap: () {
                                  navigateToScreen(
                                    context,
                                    SettingScreen(),
                                  );
                                },
                              ),
                              SizedBox(height: 24),
                              Divider(color: Colors.grey.shade100),
                              SizedBox(height: 24),
                              _ItemProfile(
                                image: Assets.icons.question.svg(height: 24),
                                title: LocaleKeys.fAQ.tr(),
                                onTap: () {},
                              ),
                              SizedBox(height: 24),
                              _ItemProfile(
                                image: Assets.icons.scale.svg(height: 24),
                                title: LocaleKeys.laws.tr(),
                                onTap: () {
                                  navigateToScreen(
                                    context,
                                    LawsScreen(),
                                  );
                                },
                              ),
                              SizedBox(height: 24),
                              _ItemProfile(
                                image: Assets.icons.code.svg(height: 24),
                                title: LocaleKeys.updateChanges.tr(),
                                onTap: () {},
                              ),
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
                                                LocaleKeys.logOutAccount.tr(),
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
                                                        _handleLogout(context);
                                                      },
                                                      child: Container(
                                                        height: 44,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff861C8C),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: NormalMedium(
                                                          LocaleKeys.yes.tr(),
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
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        height: 44,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xffCAC4CF),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: NormalMedium(
                                                            LocaleKeys.no.tr(),
                                                            textColorInLight:
                                                                Colors.white),
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
                                      LocaleKeys.logOut.tr(),
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
        ),
      ),
    ),
  );
}

class _ItemProfile extends StatelessWidget {
  final Widget image;
  final String title;
  final Function() onTap;
  const _ItemProfile({
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
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
        ),
      ),
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

void navigateToScreen(BuildContext context, Widget screen) {
  String screenName = screen.runtimeType.toString();

  if (NavigationManager.activeScreen.value == screenName) {
    return Navigator.pop(context);
  }
  NavigationManager.activeScreen.value = screenName;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => screen,
      settings: RouteSettings(name: screenName),
    ),
  ).then((_) {
    NavigationManager.activeScreen.value = null;
  });
}

class NavigationManager {
  static ValueNotifier<String?> activeScreen = ValueNotifier<String?>(null);
}

Future<void> _logoutAsync() async {
  final prefService = PrefService();
  final value = await prefService.readCacheString(SharedKey.jwtToken);
  await prefService.removeCache(SharedKey.expires);
  await prefService.removeCache(SharedKey.refreshToken);
  await prefService.removeCache(value);
}

void _handleLogout(BuildContext context) {
  _logoutAsync().then((_) {
    if (!context.mounted) return;
    _navigateToAuthScreen(context);
  });
}

void _navigateToAuthScreen(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => AuthScreen()),
    (Route<dynamic> route) => false,
  );
}
