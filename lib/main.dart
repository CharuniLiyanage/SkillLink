import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'screens/welcome_screen.dart';
import 'utils/app_colors.dart';

final FlutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ==================== Firebase ====================

  await Firebase.initializeApp();

  // ==================== Notification Permission ====================

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // ==================== Local Notifications ====================

  const AndroidInitializationSettings
      initializationSettingsAndroid =
      AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  const InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
  );

  // ==================== Android Notification Channel ====================

  const AndroidNotificationChannel channel =
      AndroidNotificationChannel(
    'skilllink_notifications',
    'SkillLink Notifications',
    description: 'Notifications from SkillLink',
    importance: Importance.high,
    playSound: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // ==================== FCM Token ====================

  final token = await FirebaseMessaging.instance.getToken();

  debugPrint('========== FCM TOKEN ==========');
  debugPrint(token);
  debugPrint('===============================');

  // ==================== Foreground FCM Messages ====================

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) async {
      debugPrint(
        'FOREGROUND FCM MESSAGE RECEIVED',
      );

      debugPrint(
        'TITLE: ${message.notification?.title}',
      );

      debugPrint(
        'BODY: ${message.notification?.body}',
      );

      const AndroidNotificationDetails
          androidNotificationDetails =
          AndroidNotificationDetails(
        'skilllink_notifications',
        'SkillLink Notifications',
        channelDescription:
            'Notifications from SkillLink',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(
        android: androidNotificationDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        id: message.hashCode,
        title: message.notification?.title ?? 'SkillLink',
        body: message.notification?.body ??
            'You have a new notification',
        notificationDetails: notificationDetails,
      );
          },
  );

  // ==================== Start App ====================

  runApp(const SkillLinkApp());
}

class SkillLinkApp extends StatelessWidget {
  const SkillLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillLink',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        scaffoldBackgroundColor:
            AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme:
            InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}