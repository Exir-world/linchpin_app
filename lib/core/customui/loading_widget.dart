import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Linchpin/core/extension/context_extension.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      height: context.screenHeight - 120,
      color: Colors.white.withValues(alpha: .5),
      child: Center(
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xff670099).withValues(alpha: 0.15),
                blurRadius: 20,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: SpinKitFadingCube(
              size: 24,
              color: Color(0xff670099),
            ),
          ),
        ),
      ),
    );
  }
}
