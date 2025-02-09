import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/colors.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
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
                                  SizedBox(height: 64),
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
                                  SizedBox(height: 64),
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
                                  SizedBox(height: 64),
                                  Row(
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
                                  SizedBox(height: 64),
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
