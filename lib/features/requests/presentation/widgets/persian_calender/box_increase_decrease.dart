import 'package:flutter/material.dart';

class BoxIncreaseDecrease extends StatelessWidget {
  /// Callback برای انجام عمل در زمان لمس دکمه.
  /// این پارامتر به صورت اختیاری وارد می‌شود و زمانی که دکمه فشرده می‌شود، فراخوانی می‌شود.
  final VoidCallback? onTap;

  /// آیکون مورد نظر که داخل دکمه نمایش داده می‌شود.
  final IconData icon;

  /// رنگ آیکون داخل دکمه.
  /// رنگ پیش‌فرض آیکون، بنفش است.
  final Color iconColor;

  const BoxIncreaseDecrease({
    super.key,
    required this.onTap, // مقدار onTap که عمل مورد نظر را هنگام لمس دکمه انجام می‌دهد.
    required this.icon, // آیکون مورد نظر که در دکمه نمایش داده می‌شود.
    this.iconColor = const Color(0xff861C8C), // رنگ پیش‌فرض آیکون، بنفش است.
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // تشخیص لمس روی دکمه و فراخوانی callback مربوطه.
      onTap: onTap,
      child: Container(
        // طراحی دکمه شامل رنگ پس‌زمینه سفید، حاشیه گرد و سایه.
        decoration: BoxDecoration(
          color: Colors.white, // رنگ پس‌زمینه دکمه سفید است.
          borderRadius: BorderRadius.circular(
              8), // گوشه‌های دکمه به‌صورت گرد طراحی شده‌اند.
          boxShadow: [
            // سایه‌ای ظریف برای دکمه به‌منظور ایجاد افکت برجسته.
            BoxShadow(
              offset: const Offset(0, 1), // موقعیت سایه.
              color: const Color(0xff030712)
                  .withValues(alpha: 0.12), // رنگ سایه با شفافیت کم.
              blurRadius: 2, // شدت تاری سایه.
            ),
          ],
        ),
        alignment: Alignment.center, // آیکون در مرکز دکمه قرار می‌گیرد.
        padding: const EdgeInsets.all(6), // فاصله داخلی دکمه از آیکون.
        child: Icon(
          icon, // آیکونی که به عنوان پارامتر به ویجت ارسال شده است.
          size: 20, // اندازه آیکون.
          color: iconColor, // رنگ آیکون که از پارامتر وارد شده است.
        ),
      ),
    );
  }
}
