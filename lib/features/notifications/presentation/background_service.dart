// background_callback.dart

import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:linchpin/core/common/constants.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:android_intent_plus/android_intent.dart';

const taskName = "location_background_task";
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Dio httpclient = Dio();
//! محدوده مجاز
bool isNear(LatLng current, LatLng target) {
  final distance = Geolocator.distanceBetween(
    current.latitude,
    current.longitude,
    target.latitude,
    target.longitude,
  );
  return distance < 100; // متر
}

//! این تابع برای اجرای کد در پس‌زمینه است
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask(
    (task, inputData) async {
      PrefService prefService = PrefService();
      String? startTime =
          await prefService.readCacheString(SharedKey.startTime);
      String? endTime = await prefService.readCacheString(SharedKey.endTime);
      String? token = await prefService.readCacheString(SharedKey.jwtToken);
      String? language =
          await prefService.readCacheString(SharedKey.selectedLanguageCode);
      final startParts = startTime?.split(":").map(int.parse).toList();
      final endParts = endTime?.split(":").map(int.parse).toList();

      final now = DateTime.now();
      final startHour = DateTime(
        now.year,
        now.month,
        now.day,
        startParts![0],
        startParts[1],
      ); // ساعت شروع کار
      final endHour = DateTime(
        now.year,
        now.month,
        now.day,
        endParts![0],
        endParts[1],
      ); // ساعت پایان کار

      if (now.isAfter(startHour) && now.isBefore(endHour)) {
        //! داخل بازه کاری هست، موقعیت رو چک کن
        if (task == taskName) {
          try {
            await flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                ?.createNotificationChannel(
                  const AndroidNotificationChannel(
                    'your_channel_id',
                    'your_channel_name',
                    importance: Importance.high,
                  ),
                );

            // check location service
            bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
            if (!serviceEnabled) {
              await httpclient.post(
                "${Constants.baseUrl}attendance/check-location",
                options: Options(
                  headers: {
                    "Authorization": "Bearer $token",
                    "Accept-Language": language ?? 'fa',
                    "Content-Type": "application/json",
                  },
                ),
                data: {
                  "lat": 0.0,
                  "lng": 0.0,
                  "gpsIsOn": false,
                },
              );
              return Future.value(true);
            } else {
              //! گرفتن آخرین موقعیت

              double latitude = 0.0;
              double longitude = 0.0;
              final position = await Geolocator.getCurrentPosition(
                locationSettings: const LocationSettings(
                  accuracy: LocationAccuracy.low,
                  distanceFilter: 0,
                ),
              );
              if (!position.latitude.isNaN && !position.longitude.isNaN) {
                latitude = position.latitude;
                longitude = position.longitude;
              } else {
                String ip = '';
                final response_ip = await http
                    .get(Uri.parse('https://api.ipify.org?format=json'));
                if (response_ip.statusCode == 200) {
                  final data = await jsonDecode(response_ip.body);
                  ip = data['ip'];
                  final response =
                      await http.get(Uri.parse('http://ip-api.com/json/$ip'));
                  if (response.statusCode == 200) {
                    final data = jsonDecode(response.body);
                    latitude = data['lat'];
                    longitude = data['lon'];
                  } else {
                    throw Exception('خطا در گرفتن لوکیشن از IP');
                  }
                } else {
                  throw Exception('خطا در گرفتن IP');
                }
              }

              await httpclient.post(
                "${Constants.baseUrl}attendance/check-location",
                options: Options(
                  headers: {
                    "Authorization": "Bearer $token",
                    "Accept-Language": language ?? 'fa',
                    "Content-Type": "application/json",
                  },
                ),
                data: {
                  "lat": latitude,
                  "lng": longitude,
                  // "lat": 0.0,
                  // "lng": 0.0,
                  "gpsIsOn": true,
                },
              );
              // if (response.statusCode == 200 || response.statusCode == 201) {
              //   print("Location sent successfully.");
              // } else {
              //   print("Failed to send location: ${response.statusCode}");
              // }
            }
          } catch (e) {
            print("Error: $e");
          }
        }
        return Future.value(true);
      } else {
        //!  خارج از تایم کاری
        return Future.value(true);
      }
    },
  );
}

class LocationServiceHelper {
  static const platform = MethodChannel('com.linchpinx.app/location');

  static Future<void> startLocationService() async {
    try {
      final result = await platform.invokeMethod('startLocationService');
      print(result);
    } on PlatformException catch (e) {
      print('Failed to start location service: ${e.message}');
    }
  }
}

Future<void> requestIgnoreBatteryOptimizations() async {
  final deviceInfo = await DeviceInfoPlugin().androidInfo;
  if (deviceInfo.version.sdkInt >= 23) {
    // فقط برای اندروید 6 (مارشمالو) به بالا

    try {
      const AndroidIntent intent = AndroidIntent(
        // action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
        action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',

        data: 'package:com.linchpinx.app.linchpinx', //  نام پکیج خود
      );
      await intent.launch();

      // await intent.launch();
    } catch (e) {
      AndroidIntent backupIntent = AndroidIntent(
        action: 'android.settings.BATTERY_SAVER_SETTINGS',
      );
      await backupIntent.launch();
      print('خطا در باز کردن تنظیمات: $e');
    }
  }
}

Future<void> showBatteryOptimizationDialog(BuildContext context) async {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(LocaleKeys.batteryoptimization.tr()),
        content: Text(
          LocaleKeys.descriptionOptimasion.tr(),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(LocaleKeys.cancel.tr()),
            onPressed: () async {
              Navigator.of(context).pop();
              await Workmanager().initialize(callbackDispatcher);

              await Future.delayed(Duration(seconds: 1));

              await Workmanager().registerPeriodicTask(
                "uniquePeriodicTaskId",
                taskName,
                frequency: const Duration(minutes: 15),
                initialDelay: Duration(seconds: 10),
                constraints: Constraints(
                  networkType: NetworkType.connected,
                ),
              );
            },
          ),
          CupertinoDialogAction(
            child: Text(LocaleKeys.settings.tr()),
            onPressed: () {
              Navigator.of(context).pop();
              requestIgnoreBatteryOptimizations().then(
                (value) async {
                  await Workmanager().initialize(callbackDispatcher);

                  await Future.delayed(Duration(seconds: 1));

                  await Workmanager().registerPeriodicTask(
                    "uniquePeriodicTaskId",
                    taskName,
                    frequency: const Duration(minutes: 15),
                    initialDelay: Duration(seconds: 10),
                    constraints: Constraints(
                      networkType: NetworkType.connected,
                    ),
                  );
                },
              );
            },
          ),
        ],
      );
    },
  );
}

class BatteryOptimization {
  static const MethodChannel _channel =
      MethodChannel('samples.flutter.dev/battery');

  static Future<bool> isIgnoringBatteryOptimizations() async {
    try {
      final bool isIgnoring =
          await _channel.invokeMethod('isIgnoringBatteryOptimizations');
      return isIgnoring;
    } on PlatformException catch (e) {
      print("خطا در دریافت وضعیت: ${e.message}");
      return false;
    }
  }
}
