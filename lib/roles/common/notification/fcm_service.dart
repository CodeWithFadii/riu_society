import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riu_society/firebase_options.dart';
import 'package:riu_society/roles/common/notification/fcm_provider.dart';

class FirebaseService {
  static FirebaseMessaging? _firebaseMessaging;
  static FirebaseMessaging get firebaseMessaging =>
      FirebaseService._firebaseMessaging ?? FirebaseMessaging.instance;

  static Future<void> intializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseService._firebaseMessaging = FirebaseMessaging.instance;
    await FirebaseService.initializeNotification();
    await FcmProvider.onMessage();
    await FcmProvider.forground();
    await FirebaseService.onBackgroundMsg();
  }

  // static getDeviceToken() async {
  //   final token = await FirebaseMessaging.instance.getToken();
  // }

  static final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotification() async {
    const InitializationSettings initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    /// on did receive notification response = for when app is opened via notification while in foreground on android
    await FirebaseService.localNotificationsPlugin.initialize(
      initSettings,
    );

    /// need this for ios foregournd notification
    await FirebaseService.firebaseMessaging
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  static void send(RemoteMessage message) async {
    final iD = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    try {
      NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
            "high_importance_channel", "High Importance Notifications",
            priority: Priority.high,
            importance: Importance.high),
      );
      await localNotificationsPlugin.show(
        iD,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static Future<void> onBackgroundMsg() async {
    FirebaseMessaging.onBackgroundMessage(FcmProvider.backgroundHandler);
  }
}
