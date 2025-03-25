import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/common/dimens.dart';
import 'package:flutter/material.dart';

class ButtonStatus extends StatelessWidget {
  final Color colorBackgerand;
  final String title;
  final Widget icon;
  final Function() onTap;
  const ButtonStatus({
    super.key,
    required this.colorBackgerand,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                color: colorBackgerand,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorBackgerand.withValues(alpha: .5),
                    blurRadius: 20.0,
                    offset: Offset(0, 4),
                  ),
                ]),
            alignment: Alignment.center,
            child: icon,
          ),
          SizedBox(height: VERTICAL_SPACING_3x),
          NormalDemiBold(
            title,
            textColorInLight: colorBackgerand,
          ),
        ],
      ),
    );
  }
}
