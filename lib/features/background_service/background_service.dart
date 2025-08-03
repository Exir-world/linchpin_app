// background_callback.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';

const taskName = "location_background_task";
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == taskName) {
      try {
        // init notification plugin
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');
        final InitializationSettings initializationSettings =
            InitializationSettings(android: initializationSettingsAndroid);

        await flutterLocalNotificationsPlugin
            .initialize(initializationSettings);

        // check location service
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          await flutterLocalNotificationsPlugin.show(
            1,
            'Location Disabled',
            'لطفاً خدمات مکان را فعال کنید.',
            NotificationDetails(
              android: AndroidNotificationDetails(
                'your_channel_id',
                'your_channel_name',
                importance: Importance.high,
                priority: Priority.high,
              ),
            ),
          );
          return Future.value(true);
        }
        // check permission
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          permission = await Geolocator.requestPermission();
        }

        final position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.low,
            distanceFilter: 0, // تعیین فاصله فیلتر
          ),
        );

        await flutterLocalNotificationsPlugin.show(
          0,
          'Location Update',
          '''موقعیت مکانی شما به‌روزرسانی شد.
          latitude : ${position.latitude}  
          longitude : ${position.longitude}''',
          NotificationDetails(
            android: AndroidNotificationDetails(
              'your_channel_id',
              'your_channel_name',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );

        // final response = await http.post(
        //   Uri.parse("https://yourserver.com/api/location"),
        //   headers: {'Content-Type': 'application/json'},
        //   body: '''
        //     {
        //       "latitude": ${position.latitude},
        //       "longitude": ${position.longitude}
        //     }
        //   ''',
        // );
        // NotificationService.showNotification(RemoteMessage(
        //   notification: RemoteNotification(
        //     title: "Location Update",
        //     body: "Your location has been updated.",
        //   ),
        // ));
        // print("Sent to server: ${response.statusCode}");
      } catch (e) {
        print("Error: $e");
      }
    }
    return Future.value(true);
  });
}
