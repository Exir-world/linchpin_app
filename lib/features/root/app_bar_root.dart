import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/colors.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

AppBar appBarRoot() {
  return AppBar(
    backgroundColor: BACKGROUND_LIGHT_APP_BAR_COLOR,
    title: Row(
      children: [
        Assets.icons.docs.svg(color: ICON_COLOR),
        Spacer(),
        NormalMedium("22"),
        SizedBox(width: 2),
        NormalMedium("دی"),
        SizedBox(width: 2),
        NormalMedium("|"),
        SizedBox(width: 2),
        NormalMedium("10:23:30"),
        SizedBox(width: 8),
        Assets.icons.calendar.svg(color: ICON_COLOR),
      ],
    ),
  );
}
