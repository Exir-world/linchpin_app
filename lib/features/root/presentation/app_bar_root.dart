import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/colors.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/requests/presentation/requests_screen.dart';
import 'package:linchpin_app/features/root/presentation/root_screen.dart';
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
    title: ValueListenableBuilder(
      valueListenable: RootScreen.timeServerNotofire,
      builder: (context, timeServer, child) {
        return Row(
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
            Spacer(),
            ValueListenableBuilder(
              valueListenable: RootScreen.timeServerNotofire,
              builder: (context, value, child) {
                return NormalMedium(value ?? '');
              },
            ),
          ],
        );
      },
    ),
  );
}
