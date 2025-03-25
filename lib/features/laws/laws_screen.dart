import 'package:flutter/material.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';

class LawsScreen extends StatelessWidget {
  const LawsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(context, true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BigDemiBold('قوانین و مقررات'),
              SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff828282).withValues(alpha: .04),
                      blurRadius: 30,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalMedium('۱. اهداف و ارزش‌ها'),
                    SizedBox(height: 12),
                    NormalMedium(
                      'رعایت اخلاق حرفه‌ای، صداقت و احترام متقابل در تمامی تعاملات.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'تعهد به کیفیت، نوآوری و بهبود مستمر در ارائه خدمات و محصولات.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'حفظ محرمانگی اطلاعات شرکت و مشتریان.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 48),
                    NormalMedium('۲. ساعات کاری و حضور'),
                    SizedBox(height: 12),
                    NormalMedium(
                      'ساعت کاری رسمی شرکت از [ساعت X] تا [ساعت Y] می‌باشد.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'تأخیر بیش از [مدت زمان] نیاز به هماهنگی و اطلاع قبلی دارد.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'اضافه‌کاری تنها با هماهنگی مدیر مربوطه مجاز است.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'تعطیلات رسمی و مرخصی‌های کارکنان بر اساس قوانین اداره کار تعیین می‌شود.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 48),
                    NormalMedium('۳. استفاده از تجهیزات و منابع شرکت'),
                    SizedBox(height: 12),
                    NormalMedium(
                      'تمامی تجهیزات و ابزارهای شرکت باید برای اهداف کاری استفاده شوند.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'استفاده شخصی از اینترنت، تلفن و سایر منابع شرکت باید در حد معقول و با اجازه مدیر باشد.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'هرگونه خسارت به اموال شرکت، ناشی از بی‌احتیاطی، بر عهده فرد مسئول خواهد بود.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 48),
                    NormalMedium(' ۴. امنیت و محرمانگی اطلاعات'),
                    SizedBox(height: 12),
                    NormalMedium(
                      'اطلاعات شرکت و مشتریان محرمانه بوده و نباید بدون اجازه فاش شوند.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'ذخیره و نگهداری اطلاعات باید مطابق با استانداردهای امنیتی شرکت باشد.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'هرگونه سوءاستفاده از اطلاعات داخلی شرکت منجر به برخورد قانونی خواهد شد.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 48),
                    NormalMedium('۵. رفتار حرفه‌ای و انضباط کاری'),
                    SizedBox(height: 12),
                    NormalMedium(
                      'رفتار حرفه‌ای و احترام به همکاران و مشتریان الزامی است.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'هرگونه رفتار ناپسند، تبعیض، آزار و اذیت در محیط کار ممنوع است.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'رعایت قوانین داخلی و همکاری در ایجاد محیطی سالم و ایمن برای همه کارکنان الزامی است.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 48),
                    NormalMedium('۶. حقوق و مزایا'),
                    SizedBox(height: 12),
                    NormalMedium(
                      'حقوق کارکنان بر اساس قرارداد منعقد شده پرداخت می‌شود.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'پاداش و مزایای اضافی بر اساس عملکرد فردی و تیمی تعیین می‌شود.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'درخواست افزایش حقوق و مزایا باید از طریق فرآیند مشخص شرکت انجام شود.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'درخواست افزایش حقوق و مزایا باید از طریق فرآیند مشخص شرکت انجام شود.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 48),
                    NormalMedium('۷. تخلفات و پیامدهای آن'),
                    SizedBox(height: 12),
                    NormalMedium(
                      'هرگونه تخلف از قوانین شرکت منجر به دریافت اخطار یا اقدامات انضباطی خواهد شد.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'در صورت تکرار تخلفات، امکان کاهش مزایا، تعلیق یا اخراج از شرکت وجود دارد.',
                      textColorInLight: Color(0xff828282),
                    ),
                    SizedBox(height: 12),
                    NormalMedium(
                      'شرکت حق دارد در صورت نقض جدی مقررات، از طریق مراجع قانونی اقدام کند.',
                      textColorInLight: Color(0xff828282),
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
