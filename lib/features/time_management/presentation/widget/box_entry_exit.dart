import 'package:linchpin/core/common/text_widgets.dart';
import 'package:flutter/material.dart';

class BoxEntryExit extends StatelessWidget {
  final Widget image;
  final String title;
  final String time;
  const BoxEntryExit({
    super.key,
    required this.image,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            offset: Offset(0, 3),
            color: Color(0xff828282).withValues(alpha: .05),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          image,
          SmallMedium(title),
          SmallBold(time),
        ],
      ),
    );
  }
}
