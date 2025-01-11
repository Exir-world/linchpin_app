import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/icon_widget.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';

AppBar appBarRoot() {
  return AppBar(
    backgroundColor: Colors.white,
    title: Row(
      children: [
        NormalIcon(Icons.calendar_month_outlined),
        SizedBox(width: 8),
        NormalMedium("10:23:30"),
        SizedBox(width: 2),
        NormalMedium("|"),
        SizedBox(width: 2),
        NormalMedium("دی"),
        SizedBox(width: 2),
        NormalMedium("22"),
        Spacer(),
        NormalIcon(Icons.add_circle_outline_sharp),
      ],
    ),
  );
}
