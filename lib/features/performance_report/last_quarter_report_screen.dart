import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/dimens.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class LastQuarterReportScreen extends StatelessWidget {
  const LastQuarterReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding_Horizantalx),
        child: Column(
          children: [
            SizedBox(height: VERTICAL_SPACING_6x),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LargeDemiBold("گزارش عملکرد 3 ماهه"),
                NormalMedium(
                  'مشاهده همه',
                  textColorInLight: Color(0xff861C8C),
                ),
              ],
            ),
            SizedBox(height: VERTICAL_SPACING_6x),
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Assets.icons.spring.svg(),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                NormalMedium('ساعات کاری فروردین 1403'),
                                SmallMedium('144 ساعت'),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Color(0xffF5EEFC),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.center,
                                  child: SmallRegular(
                                    'مفید: 148 ساعت',
                                    textColorInLight: Color(0xff9B51E0),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Color(0xffFEF5ED),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.center,
                                  child: SmallRegular(
                                    'مفید: 148 ساعت',
                                    textColorInLight: Color(0xffFFA656),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color(0xffDADADA),
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
