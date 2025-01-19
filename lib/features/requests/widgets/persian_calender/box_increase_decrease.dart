import 'package:flutter/material.dart';

class BoxIncreaseDecrease extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color iconColor;

  const BoxIncreaseDecrease({
    super.key,
    required this.onTap,
    required this.icon,
    this.iconColor = const Color(0xff861C8C),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              color: const Color(0xff030712).withValues(alpha: 0.12),
              blurRadius: 2,
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
      ),
    );
  }
}
