import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmController extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    messaging.getToken().then((value) {
      print("Firebase Messaging Token: $value");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print('A new message arrived: ${notification.body}');
      }
    });
  }

  void subscribeToTopic(String topic) {
    messaging.subscribeToTopic(topic);
  }
}