import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/colors.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/requests/requests_screen.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

AppBar appBarRoot(BuildContext context, bool isRequestScreen) {
  return AppBar(
    backgroundColor: BACKGROUND_LIGHT_APP_BAR_COLOR,
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
    title: Row(
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
                child: Assets.icons.docs.svg(height: 26),
              )
            : SizedBox.shrink(),
        Spacer(),
        NormalMedium("22"),
        SizedBox(width: 2),
        NormalMedium("دی"),
        SizedBox(width: 2),
        NormalMedium("|"),
        SizedBox(width: 2),
        NormalMedium("10:23:30"),
        SizedBox(width: 8),
        Assets.icons.calendar.svg(),
      ],
    ),
  );
}
