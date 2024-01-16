import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('title: ${message.notification?.title}');
    print('body: ${message.notification?.body}');
    print('data: ${message.data}');
  }

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    final fcmToken = await firebaseMessaging.getToken();

    print('FCM Token: $fcmToken');

    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    // initPushNotifications();
  }

  // void handleMessage(RemoteMessage? message) {
  //   if (message == null) return;
  //   Get.toNamed(Routes.NOTIFICATIONS, arguments: message);
  // }

  // Future initPushNotifications() async {
  //   FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  //   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  // }
}
