import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/dimens.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

// نمایش پیغام موفقیت آمیز از پایین صفحه
SnackBar snackBarVerify(
    {required BuildContext context,
    required String title,
    required String desc}) {
  return SnackBar(
    dismissDirection: DismissDirection.up,
    elevation: 0,
    backgroundColor: Colors.transparent,
    margin: const EdgeInsets.only(
      top: 50,
      left: 10,
      right: 10,
    ), // تنظیم حاشیه از بالا
    behavior: SnackBarBehavior.floating, // برای نمایش شناور
    content: Container(
      height: 48,
      decoration: BoxDecoration(
        color: Color(0xff302432),
        borderRadius: BorderRadius.circular(RADIUS_4x),
      ),
      child: Row(
        children: [
          SizedBox(width: 12),
          Assets.icons.verify.image(),
          SizedBox(width: 12),
          SmallRegular(
            title,
            textColorInLight: Color(0xffC8C5C5),
          ),
        ],
      ),
    ),
  );
}
