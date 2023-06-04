import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'SCREENS/ChatScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'STYLES/AppTheme.dart';
import 'firebase_options.dart';

// --------------------------------------------------------------
// TEST CODE OK =>customer_id = FXS9GNEH2E    -> tag Id = 6QXAE9IZ6G (Chez Remy Home)
// TEST CODE OK => customer_id = 1D8NXQ39LT -> tagid = SIJYXQNR2V
// TEST CODE OK => customer_id = 3NSJV1E3CC -> tagid = HCFQ2HH89B  (Chez Gilles Home)
// --------------------------------------------------------------

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform);
}

AndroidNotificationChannel? channel;

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
late FirebaseMessaging messaging;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  //If subscribe based sent notification then use this token
  final fcmToken = await messaging.getToken();
  print(fcmToken);

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRING',
      theme: appThemeData,
      home: ChatScreen(),
    );
  }
}

