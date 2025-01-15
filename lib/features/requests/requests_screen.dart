import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/dimens.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/requests/request_detail_screen.dart';
import 'package:linchpin_app/features/root/presentation/app_bar_root.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(context, true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding_Horizantalx),
          child: Column(
            children: [
              SizedBox(height: 24),
              Row(
                children: [
                  BigDemiBold('درخواست ها'),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestDetailScreen(),
                          ));
                    },
                    child: Row(
                      children: [
                        Assets.icons.plus.svg(),
                        SizedBox(width: 8),
                        NormalMedium('ثبت درخواست جدید'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    height: 92,
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  NormalRegular('تردد دستی (ورود) - '),
                                  NormalRegular('1403/10/8'),
                                  Spacer(),
                                  SmallRegular(
                                    'ثبت شده',
                                    textColorInLight: Color(0xff828282),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Assets.icons.clockAddPlus.svg(
                                    width: 16,
                                    height: 16,
                                    color: Color(0xff861C8C),
                                  ),
                                  SizedBox(width: 8),
                                  SmallRegular(
                                    'ورود برای ساعت 7:45',
                                    textColorInLight: Color(0xff861C8C),
                                  ),
                                  Spacer(),
                                  Assets.icons.tag.svg(),
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
      ),
    );
  }
}
