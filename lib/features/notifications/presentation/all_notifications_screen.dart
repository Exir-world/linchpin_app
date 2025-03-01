import 'package:linchpin/core/common/text_widgets.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/features/notifications/presentation/notifications_screen.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';
import 'package:linchpin/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class AllNotificationsScreen extends StatelessWidget {
  const AllNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<int> listTest = [0];
    return Scaffold(
      appBar: appBarRoot(context, true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24),
              TitleScreen(
                title: 'اعلانات',
                icon: Assets.icons.delete.svg(),
                desc: 'پاک کردن اعلان ها',
                onTap: () {},
              ),
              SizedBox(height: 40),
              listTest.isNotEmpty
                  ? ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ItemNotifList(
                          color: Colors.amber,
                          isread: true,
                          title: 'تسک جدید برای شما اضافه شد',
                          desc: 'طراحی لندینگ جدید سیکادا',
                          date: '۱۴۰۳/۱/۲',
                          onTap: () {},
                          icon: Assets.icons.board.svg(),
                        );
                      },
                    )
                  : SizedBox(
                      height: context.screenHeight / 2,
                      child: Center(
                        child: NormalRegular(
                          'اعلان جدیدی ندارید.',
                          textColorInLight: Color(0xffCAC4CF),
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
