import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/colors.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/requests/presentation/requests_screen.dart';
import 'package:linchpin_app/features/root/presentation/root_screen.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

PreferredSize appBarRoot(BuildContext context, bool isRequestScreen) {
  return PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color:
                Color(0xff828282).withValues(alpha: 0.15), // میزان تیرگی سایه
            blurRadius: 100, // میزان محوشدگی سایه
            spreadRadius: 0, // میزان گسترش سایه
            offset: Offset(0, -8), // جهت سایه (افقی، عمودی)
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: BACKGROUND_LIGHT_APP_BAR_COLOR,
        forceMaterialTransparency: false,
        surfaceTintColor: Colors.transparent,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ValueListenableBuilder(
                  valueListenable: RootScreen.timeServerNotofire,
                  builder: (context, value, child) {
                    return NormalMedium(value ?? '');
                  },
                ),
                Assets.icons.user.svg(height: 26),
              ],
            );
          },
        ),
      ),
    ),
  );
}
