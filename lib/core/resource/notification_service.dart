import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:news_app/core/data/model/news_model.dart';
import 'package:news_app/core/resource/theme_notifier.dart';
import 'package:news_app/feature/page/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const _enableAlarmKey = 'enable_news_notification';
  static const _channelName = 'news_notification_name';
  static const _channelId = "1";

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    _channelId,
    _channelName,
    description: 'This channel is used for news notifications.',
    importance: Importance.high,
    playSound: true,
  );

  static saveSettings(bool value, NewsModel? newsModel, BuildContext? context,
      ThemeNotifier? theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_enableAlarmKey, value);

    if (value == true) {
      await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestExactAlarmsPermission();
      await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      var androidInitializationSettings =
          const AndroidInitializationSettings('@mipmap/ic_launcher');

      final InitializationSettings initializationSettings =
          InitializationSettings(android: androidInitializationSettings);

      FlutterLocalNotificationsPlugin().initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          Navigator.push(
              context as BuildContext,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(title: 'News App', theme: theme as ThemeNotifier)));
        },
      );

      final now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        10, // 10:00 AM
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await FlutterLocalNotificationsPlugin().zonedSchedule(
          2,
          newsModel?.title,
          newsModel?.description,
          scheduledDate,
          const NotificationDetails(
              android: AndroidNotificationDetails(_channelId, _channelName)),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);
    } else {
      await FlutterLocalNotificationsPlugin().cancel(2);
    }
  }

  Future<dynamic> readSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(_enableAlarmKey);
  }
}
