import 'package:calendar_pro_farhad/core/text_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/auth/presentation/auth_screen.dart';
import 'package:linchpin/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AccessLocationScreen extends StatefulWidget {
  final bool isFirstApp;
  const AccessLocationScreen({super.key, required this.isFirstApp});

  @override
  State<AccessLocationScreen> createState() => _AccessLocationScreenState();
  static ValueNotifier<double?> latitudeNotifire = ValueNotifier(null);
  static ValueNotifier<double?> longitudeNotifire = ValueNotifier(null);
}

class _AccessLocationScreenState extends State<AccessLocationScreen> {
  ValueNotifier<bool> isLoadingNotifire = ValueNotifier(false);

  // متد برای درخواست دسترسی و دریافت موقعیت مکانی
  Future<void> _requestPermissionAndGetLocation() async {
    isLoadingNotifire.value = true;

    if (kIsWeb) {
      try {
        Position position = await Geolocator.getCurrentPosition();
        AccessLocationScreen.latitudeNotifire.value = position.latitude;
        AccessLocationScreen.longitudeNotifire.value = position.longitude;
        isLoadingNotifire.value = false;
        widget.isFirstApp
            ? Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AuthScreen()),
              )
            : Navigator.pop(context);
      } catch (e) {
        isLoadingNotifire.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("خطا در دریافت موقعیت مکانی: ${e.toString()}")),
        );
      }
    } else {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        isLoadingNotifire.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("دسترسی به موقعیت مکانی برای همیشه رد شده است")),
        );
        return;
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        await _getCurrentLocation();
      } else {
        isLoadingNotifire.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("دسترسی به موقعیت مکانی رد شده است")),
        );
      }
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
      AccessLocationScreen.latitudeNotifire.value = position.latitude;
      AccessLocationScreen.longitudeNotifire.value = position.longitude;
      isLoadingNotifire.value = false;
      widget.isFirstApp
          ? Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AuthScreen()),
            )
          : Navigator.pop(context);
    } catch (e) {
      isLoadingNotifire.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: NormalMedium(LocaleKeys.retrievingLocationText.tr())),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LargeRegular(LocaleKeys.dearUser.tr()),
                  ],
                ),
                LargeRegular(
                  LocaleKeys.permissionsText.tr(),
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
                    LargeDemiBold(LocaleKeys.locationText.tr()),
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
                                LocaleKeys.confirmation.tr(),
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
