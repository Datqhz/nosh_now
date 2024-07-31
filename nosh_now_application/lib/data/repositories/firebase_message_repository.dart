import 'dart:convert';

import 'package:http/http.dart';

class FirebaseMessageRepository {
  Future<void> sendPushMessage(
      String topic, String title, String message, Map<String, dynamic> data) async {
    const String url =
        'https://fcm.googleapis.com/v1/projects/nosh-62d66/messages:send';
    try {
      final response = await post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            // 'Authorization': 'Bearer ${GlobalVariable.messageOAuthToken}',
          },
          body: jsonEncode(
            <String, dynamic>{
              "message": {
                "topic": topic,
                "notification": {"title": title, "body": message},
                "data": data
              }
            },
          ));
      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
