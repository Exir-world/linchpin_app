import 'package:flutter/material.dart';

class MaxWidthWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const MaxWidthWrapper({super.key, required this.child, this.maxWidth = 650});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width =
            constraints.maxWidth > maxWidth ? maxWidth : constraints.maxWidth;
        return Center(
          child: SizedBox(
            width: width,
            child: child,
          ),
        );
      },
    );
  }
}
