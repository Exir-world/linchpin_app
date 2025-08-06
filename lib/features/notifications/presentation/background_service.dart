// background_callback.dart

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:latlong2/latlong.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';

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
  Workmanager().executeTask((task, inputData) async {
    PrefService prefService = PrefService();
    String? startTime = await prefService.readCacheString(SharedKey.startTime);
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
          // await flutterLocalNotificationsPlugin
          //     .resolvePlatformSpecificImplementation<
          //         AndroidFlutterLocalNotificationsPlugin>()
          //     ?.createNotificationChannel(
          //       const AndroidNotificationChannel(
          //         'your_channel_id',
          //         'your_channel_name',
          //         importance: Importance.high,
          //       ),
          //     );

          // check location service
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            final response = await httpclient.post(
              "https://linchpin.ex.pro/api/attendance/check-location",
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
            if (response.statusCode == 200) {
              print("Location sent successfully.");
            } else {
              print("Failed to send location: ${response.statusCode}");
            }
            return Future.value(true);
          } else {
            // final position = await Geolocator.getCurrentPosition(
            //   locationSettings: const LocationSettings(
            //     accuracy: LocationAccuracy.high,
            //     distanceFilter: 0,
            //   ),
            // );

            final response = await httpclient.post(
              "https://linchpin.ex.pro/api/attendance/check-location",
              options: Options(
                headers: {
                  "Authorization": "Bearer $token",
                  "Accept-Language": language ?? 'fa',
                  "Content-Type": "application/json",
                },
              ),
              data: {
                // "lat": position.latitude,
                // "lng": position.longitude,
                "lat": 0.0,
                "lng": 0.0,
                "gpsIsOn": true,
              },
            );
            if (response.statusCode == 200 || response.statusCode == 201) {
              print("Location sent successfully.");
            } else {
              print("Failed to send location: ${response.statusCode}");
            }
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
  });
}
