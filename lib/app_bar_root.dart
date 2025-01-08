import 'package:flutter/material.dart';

AppBar appBarRoot() {
  return AppBar(
    backgroundColor: Colors.white,
    title: Row(
      children: [
        Icon(
          Icons.calendar_month_outlined,
          color: Color(0xff861C8C),
        ),
        SizedBox(width: 8),
        Text(
          "10:23:30",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xff861C8C),
          ),
        ),
        SizedBox(width: 2),
        Text(
          "|",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xff861C8C),
          ),
        ),
        SizedBox(width: 2),
        Text(
          "دی",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xff861C8C),
          ),
        ),
        SizedBox(width: 2),
        Text(
          "22",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xff861C8C),
          ),
        ),
        Spacer(),
        Icon(
          Icons.add_circle_outline_sharp,
          color: Color(0xff861C8C),
          size: 30,
        ),
      ],
    ),
  );
}
