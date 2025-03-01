import 'package:flutter/foundation.dart';
import 'package:linchpin/core/common/text_widgets.dart';
import 'package:linchpin/features/auth/presentation/auth_screen.dart';
import 'package:linchpin/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AccessLocationScreen extends StatefulWidget {
  const AccessLocationScreen({super.key});

  @override
  State<AccessLocationScreen> createState() => _AccessLocationScreenState();
}

class _AccessLocationScreenState extends State<AccessLocationScreen> {
  ValueNotifier<bool> isLoadingNotifire = ValueNotifier(false);

  // متد برای درخواست دسترسی و دریافت موقعیت مکانی
  Future<void> _requestPermissionAndGetLocation() async {
    isLoadingNotifire.value = true;
    // بررسی دسترسی‌های فعلی
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // اگر دسترسی رد شده باشد، درخواست مجدد می‌شود
      permission = await Geolocator.requestPermission();
    }
    // اگر دسترسی به طور دائم رد شده باشد
    if (permission == LocationPermission.deniedForever) {
      isLoadingNotifire.value = false;
      // نمایش پیغام خطا و ارائه دکمه برای باز کردن تنظیمات
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('برای ادامه، باید از تنظیمات دسترسی بدهید.'),
          action: SnackBarAction(
            label: 'تنظیمات',
            onPressed: () {
              if (!kIsWeb) {
                Geolocator.openAppSettings();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("این قابلیت در نسخه وب پشتیبانی نمی‌شود.")),
                );
              }
            },
          ),
        ),
      );
      return;
    }
    // اگر دسترسی معتبر باشد، موقعیت مکانی را دریافت می‌کنیم
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await _getCurrentLocation();
    } else {
      isLoadingNotifire.value = false;
      // نمایش پیغام برای درخواست دسترسی
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('دسترسی به لوکیشن رد شد. لطفاً مجوز لازم را بدهید.'),
        ),
      );
    }
  }

  // متد برای دریافت موقعیت مکانی فعلی
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
      isLoadingNotifire.value = false;
      return;
    }
    try {
      // دریافت موقعیت مکانی با دقت بالا
      Position position = await Geolocator.getCurrentPosition();
      print("موقعیت دریافت شد: ${position.latitude}, ${position.longitude}");
      isLoadingNotifire.value = false;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthScreen()),
      );
    } catch (e) {
      isLoadingNotifire.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('مشکلی در دریافت موقعیت مکانی رخ داد.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Color(0xffE0E0F9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Assets.icons.location.svg(),
                ),
                SizedBox(height: 32),
                Align(
                    alignment: Alignment.centerRight,
                    child: LargeRegular('کاربر گرامی')),
                LargeRegular(
                  'اپلیکیشن لینچپین برای ثبت ترددهای شما نیاز به مجوزهای زیر دارد. لطفا برای استفاده از اپلیکیشن، دسترسی‌های مورد نیاز را بدهید:',
                ),
                SizedBox(height: 48),
                Row(
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      margin: EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff540E5C),
                      ),
                    ),
                    SizedBox(width: 12),
                    LargeDemiBold('دسترسی به Location (مکان کنونی کاربر)'),
                  ],
                ),
                Spacer(),
                ValueListenableBuilder(
                  valueListenable: isLoadingNotifire,
                  builder: (context, value, child) {
                    return GestureDetector(
                      onTap: value ? null : _requestPermissionAndGetLocation,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: value ? Colors.grey : Color(0xff861C8C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: value
                            ? CupertinoActivityIndicator(color: Colors.white)
                            : LargeMedium(
                                'تایید',
                                textColorInLight: Colors.white,
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
