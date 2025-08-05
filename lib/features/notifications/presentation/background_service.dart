// background_callback.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:latlong2/latlong.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';

const taskName = "location_background_task";
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
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
          // final response = await http.post(
          //   Uri.parse("https://yourserver.com/api/location"),
          //   headers: {'Content-Type': 'application/json'},
          //   body: jsonEncode({
          //     "latitude": null,
          //     "longitude": null,
          //     "status_location": false,
          //   }),
          // );
          // if (response.statusCode == 200) {
          //   print("Location sent successfully.");
          // } else {
          //   print("Failed to send location: ${response.statusCode}");
          // }
          await flutterLocalNotificationsPlugin.show(
            0,
            'خطا در دسترسی به موقعیت مکانی',
            'لطفاً سرویس موقعیت مکانی را فعال کنید.',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'location_channel',
                'Location Notifications',
                importance: Importance.high,
                priority: Priority.high,
              ),
            ),
          );
          return Future.value(true);
        } else {
          final position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 0,
            ),
          );

          if (isNear(
            LatLng(position.latitude, position.longitude), // موقعیت فعلی
            LatLng(36.2978647, 59.5906685), // موقعیت مورد نظر
          )) {
            await flutterLocalNotificationsPlugin.show(
              0,
              'Location Update',
              'شما در موقعیت مورد نظر هستید.',
              NotificationDetails(
                android: AndroidNotificationDetails(
                  'your_channel_id',
                  'your_channel_name',
                  importance: Importance.max,
                  priority: Priority.high,
                ),
              ),
            );
            return Future.value(true);
          } else {
            // final body = jsonEncode({
            //   "latitude": position?.latitude,
            //   "longitude": position?.longitude,
            // });
            // final response = await http.post(
            //   Uri.parse("https://yourserver.com/api/location"),
            //   headers: {'Content-Type': 'application/json'},
            //   body: body,
            // );
            // if (response.statusCode == 200) {
            //   print("Location sent successfully.");
            // } else {
            //   print("Failed to send location: ${response.statusCode}");
            // }
            await flutterLocalNotificationsPlugin.show(
              0,
              'Location Update',
              'شما در موقعیت مورد نظر نیستید.',
              NotificationDetails(
                android: AndroidNotificationDetails(
                  'your_channel_id',
                  'your_channel_name',
                  importance: Importance.max,
                  priority: Priority.high,
                ),
              ),
            );
          }
        }
        //! check permission
        // LocationPermission permission = await Geolocator.checkPermission();
        // if (permission == LocationPermission.denied ||
        //     permission == LocationPermission.deniedForever) {
        //   permission = await Geolocator.requestPermission();
        // }

        // LocationService locationService = LocationService();
        // final position = await locationService.getUserLocation();
      } catch (e) {
        print("Error: $e");
      }
    }
    return Future.value(true);
  });
}
