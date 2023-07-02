import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomFirebaseMessagingService {
  static void init() {
    // For web and ios
    FirebaseMessaging.instance.requestPermission();

    // // app is opened
    // FirebaseMessaging.onMessage.listen((event) {
    //   print("onMessage: $event");
    // });
    //
    // // notification is clicked / tapped
    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   print("onMessageOpenedApp: $event");
    // });
  }

  ///   Return device token
  static Future<String?> getToken() async {
    if (kIsWeb) {
      return await FirebaseMessaging.instance
          .getToken(vapidKey: dotenv.env['VAPID_KEY']);
    } else {
      return await FirebaseMessaging.instance.getToken();
    }
  }
}
