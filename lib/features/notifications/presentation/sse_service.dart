import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
// import 'notification_service.dart';

class PushNotificationService {
  final String baseUrl;
  final String userId;
  final String? jwtToken; // برای احراز هویت (اختیاری)
  StreamController<Map<String, dynamic>>? _notificationController;
  http.Client? _client;

  PushNotificationService({
    required this.baseUrl, 
    required this.userId,
    this.jwtToken,
  });

  // ثبت توکن دستگاه
  Future<void> registerDevice() async {
    final deviceToken = const Uuid().v4();
    final response = await http.post(
      Uri.parse('$baseUrl/push-notifications/register'),
      headers: {
        'Content-Type': 'application/json',
        if (jwtToken != null) 'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'user_id': userId,
        'device_token': deviceToken,
        'platform': 'android',
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register device: ${response.body}');
    }
  }

  // اتصال به SSE
  void connectToSSE() {
    _notificationController = StreamController<Map<String, dynamic>>();
    _client = http.Client();

    final request = http.Request(
      'GET',
      Uri.parse('$baseUrl/push-notifications/sse/$userId'),
    );

    if (jwtToken != null) {
      request.headers['Authorization'] = 'Bearer $jwtToken';
    }

    _client!.send(request).then((response) {
      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen(
          (data) {
            // بررسی فرمت داده SSE
            if (data.startsWith('data: ')) {
              try {
                final message = jsonDecode(data.substring(6)); // حذف "data: "
                _notificationController!.add(message);
              } catch (e) {
                print('Error parsing SSE data: $e');
              }
            }
          },
          onError: (error) {
            print('SSE error: $error');
            _notificationController!.addError(error);
          },
          onDone: () {
            print('SSE connection closed');
            _notificationController!.close();
          },
        );
      } else {
        _notificationController!.addError(
          Exception('Failed to connect to SSE: ${response.statusCode}'),
        );
      }
    }).catchError((error) {
      print('SSE connection error: $error');
      _notificationController!.addError(error);
    });
  }

  // دریافت استریم نوتیفیکیشن‌ها
  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController!.stream;

  // بستن اتصال SSE
  void dispose() {
    _notificationController?.close();
    _client?.close();
  }
}
