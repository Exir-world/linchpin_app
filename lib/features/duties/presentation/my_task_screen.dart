import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/duties/presentation/duties_screen.dart';
import 'package:linchpin_app/features/root/presentation/app_bar_root.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class MyTaskScreen extends StatelessWidget {
  const MyTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(context, true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // کارت جزئیات تسک
              TaskDescWidget(),
              SizedBox(height: 16),
              // کارت پیوست ها
              AttachTaskWidget(),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Assets.icons.task.svg(height: 24),
                        SizedBox(width: 8),
                        NormalMedium('ساب تسک ها'),
                      ],
                    ),
                    SizedBox(height: 24),
                    ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              index == 2
                                  ? Assets.icons.check.svg()
                                  : Assets.icons.cir.svg(),
                              SizedBox(width: 12),
                              SmallRegular(
                                'طراحی بنر سیکادا',
                                decoration: index == 2
                                    ? TextDecoration.lineThrough
                                    : null,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// کارت پیوست ها
class AttachTaskWidget extends StatelessWidget {
  const AttachTaskWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              Assets.icons.attach.svg(height: 24),
              SizedBox(width: 8),
              NormalMedium('فایل های پیوست'),
            ],
          ),
          SizedBox(height: 24),
          ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                height: 72,
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xffF9F8FE).withValues(alpha: .7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Assets.icons.download.svg(height: 20),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SmallMedium('Design Brief.pdf'),
                        VerySmallRegular(
                          '۳۱۳ کیلوبایت',
                          textColorInLight: Color(0xff88719B),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Assets.images.pdf.svg(),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

// کارت جزئیات تسک
class TaskDescWidget extends StatelessWidget {
  const TaskDescWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff030712).withValues(alpha: .12),
                      blurRadius: 0,
                      spreadRadius: 1.2,
                    ),
                    BoxShadow(
                      color: Color(0xff030712).withValues(alpha: .12),
                      blurRadius: 2.4,
                      offset: Offset(0, 1.2),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              NormalMedium('طراحی لندینگ سیکادا'),
            ],
          ),
          SizedBox(height: 24),
          SmallRegular(
            'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است،',
            textColorInLight: Color(0xff828282),
          ),
          SizedBox(height: 24),
          // SizedBox(
          //   height: 26,
          //   child: ListView.builder(
          //     itemCount: 3,
          //     shrinkWrap: true,
          //     scrollDirection: Axis.horizontal,
          //     itemBuilder: (context, index) {
          //       return Padding(
          //         padding: const EdgeInsets.only(left: 8),
          //         child: TagContainer(
          //           tag: 'دیزاین',
          //           color: Color(0xffB10000),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          SizedBox(height: 24),
          Row(
            children: [
              Assets.icons.avatar.svg(),
              SizedBox(width: 8),
              SmallMedium('زهرا محمدی'),
              Spacer(),
              Assets.icons.flag1.svg(),
              SizedBox(width: 4),
              SmallMedium(
                'مهم و فوری',
                textColorInLight: Color(0xffFD5B71),
              ),
              Spacer(),
              SmallRegular(
                '22 آذر',
                textColorInLight: Color(0xff88719B),
              ),
              SizedBox(width: 4),
              Assets.icons.calendar.svg(color: Color(0xff88719B)),
            ],
          ),
        ],
      ),
    );
  }
}
