import 'package:flutter/material.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/features/property/data/models/my_properties_model/property.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';
import 'package:linchpin/gen/assets.gen.dart';
import 'package:shamsi_date/shamsi_date.dart';

class DetailPropertyScreen extends StatelessWidget {
  final Property property;
  final DateTime deliveredAt;
  const DetailPropertyScreen(
      {super.key, required this.property, required this.deliveredAt});

  @override
  Widget build(BuildContext context) {
    final date = deliveredAt.toJalali();
    String year = date.year.toString();
    String month = date.month.toString();
    String day = date.day.toString();
    return Scaffold(
      appBar: appBarRoot(
        context,
        true,
        () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalDemiBold(property.title!),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      NormalRegular(
                        'کد اموال:',
                        textColorInLight: Color(0xff4F4F4F),
                      ),
                      SizedBox(width: 4),
                      NormalRegular(
                        property.code!,
                        textColorInLight: Color(0xff4F4F4F),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      NormalRegular(
                        'وضعیت:',
                        textColorInLight: Color(0xff4F4F4F),
                      ),
                      SizedBox(width: 4),
                      NormalRegular(
                        property.status!,
                        textColorInLight: Color(0xff4F4F4F),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Assets.icons.calendar.svg(color: Color(0xff4F4F4F)),
                      SizedBox(width: 4),
                      NormalRegular(
                        'تحویل:',
                        textColorInLight: Color(0xff4F4F4F),
                      ),
                      SizedBox(width: 4),
                      NormalRegular(
                        '$year/$month/$day',
                        textColorInLight: Color(0xff4F4F4F),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 272,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Image.network('${property.imageUrl}'),
            ),
          ],
        ),
      ),
    );
  }
}
