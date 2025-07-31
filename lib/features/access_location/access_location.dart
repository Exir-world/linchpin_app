import 'package:calendar_pro_farhad/core/text_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/auth/presentation/pages/auth_screen.dart';
import 'package:linchpin/features/root/presentation/root_screen.dart';
import 'package:linchpin/gen/assets.gen.dart';

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
                    color: const Color(0xffE0E0F9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Assets.icons.location.svg(),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LargeRegular(LocaleKeys.dearUser.tr()),
                  ],
                ),
                LargeRegular(LocaleKeys.permissionsText.tr()),
                const SizedBox(height: 48),
                Row(
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff540E5C),
                      ),
                    ),
                    const SizedBox(width: 12),
                    LargeDemiBold(LocaleKeys.locationText.tr()),
                  ],
                ),
                const Spacer(),
                ValueListenableBuilder<bool>(
                  valueListenable: isLoadingNotifire,
                  builder: (context, isLoading, _) {
                    return GestureDetector(
                      onTap: isLoading ? null : _handleLocationAccess,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color:
                              isLoading ? Colors.grey : const Color(0xff861C8C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: isLoading
                            ? const CupertinoActivityIndicator(
                                color: Colors.white)
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

  //! تابع اصلی برای کنترل دسترسی به موقعیت مکانی و هدایت صفحه
  void _handleLocationAccess() async {
    isLoadingNotifire.value = true;
    LocationService locationService = LocationService();
    final position = await locationService.getUserLocation();
    if (!mounted) return;

    if (position == null) {
      isLoadingNotifire.value = false;
      _showSnackbar("خطا در دریافت موقعیت مکانی یا دسترسی رد شده است.");
      return;
    }

    AccessLocationScreen.latitudeNotifire.value = position.latitude;
    AccessLocationScreen.longitudeNotifire.value = position.longitude;

    final token = await _getUserToken();
    if (!mounted) return;

    isLoadingNotifire.value = false;

    if (token == null) {
      _goTo(const AuthScreen());
    } else {
      widget.isFirstApp ? _goTo(const RootScreen()) : Navigator.pop(context);
    }
  }

  //! دریافت توکن از SharedPreferences
  Future<String?> _getUserToken() async {
    final prefService = PrefService();
    return await prefService.readCacheString(SharedKey.jwtToken);
  }

  //! هدایت به یک صفحه جدید
  void _goTo(Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  //! نمایش پیام خطا
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

//! دریافت موقعیت مکانی کاربر
class LocationService {
  Future<Position?> getUserLocation() async {
    if (kIsWeb) {
      try {
        return await Geolocator.getCurrentPosition();
      } catch (_) {
        return null;
      }
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always)) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }
}
