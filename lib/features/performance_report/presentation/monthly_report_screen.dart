import 'package:calendar_pro_farhad/core/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';
import 'package:linchpin/gen/assets.gen.dart';

class MonthlyReportScreen extends StatefulWidget {
  final String title;
  const MonthlyReportScreen({super.key, required this.title});

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(context, true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24),
              Row(
                children: [
                  BigDemiBold(widget.title),
                  Spacer(),
                  Assets.icons.documentPdf.svg(),
                  SizedBox(width: 8),
                  NormalMedium('دانلود PDF'),
                ],
              ),
              SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        BoxTitle(
                          title: 'حضور کل: ۲۱۵ ساعت',
                          color: Color(0xffE6FCF4),
                          titleColor: Color(0xff02B776),
                        ),
                        SizedBox(width: 8),
                        BoxTitle(
                          title: 'کار مفید: ۱۴۸ ساعت',
                          color: Color(0xffF5EEFC),
                          titleColor: Color(0xff9B51E0),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        BoxTitle(
                          title: 'اضافه کار: ۲۲ ساعت',
                          color: Color(0xffE5F5FF),
                          titleColor: Color(0xff4897F1),
                        ),
                        SizedBox(width: 8),
                        BoxTitle(
                          title: 'کسری: ۴ ساعت',
                          color: Color(0xffFFEFF1),
                          titleColor: Color(0xffFD5B71),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        BoxTitle(
                          title: 'مرخصی بدون حقوق: ۲۴ ساعت',
                          color: Color(0xffFEF5ED),
                          titleColor: Color(0xffF08B32),
                        ),
                        SizedBox(width: 8),
                        BoxTitle(
                          title: 'مرخصی با حقوق: ۲۴ ساعت',
                          color: Color(0xffFEF5ED),
                          titleColor: Color(0xffF08B32),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            NormalRegular('یکشنبه ۱۴۰۳/۰۱/۰۱'),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xffF5EEFC),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: VerySmallRegular(
                                'کار مفید: ۱۴۸ ساعت',
                                textColorInLight: Color(0xff9B51E0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Assets.icons.checkIn.svg(),
                            SizedBox(width: 4),
                            NormalRegular(
                              'اولین ورود: ۱۸:۲۳',
                              textColorInLight: Color(0xff861C8C),
                            ),
                            SizedBox(width: 16),
                            Assets.icons.checkOut.svg(height: 18),
                            SizedBox(width: 4),
                            NormalRegular(
                              'آخرین خروج: ۲۰:۲۳',
                              textColorInLight: Color(0xff861C8C),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xffDADADA),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BoxTitle extends StatelessWidget {
  final String title;
  final Color color;
  final Color titleColor;
  const BoxTitle({
    super.key,
    required this.title,
    required this.color,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: VerySmallRegular(
          title,
          textColorInLight: titleColor,
        ),
      ),
    );
  }
}
