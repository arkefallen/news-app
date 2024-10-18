import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/resource/notificiation_notifier.dart';
import 'package:news_app/core/resource/theme_notifier.dart';
import 'package:provider/provider.dart';
import '../feature/page/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ChangeNotifierProvider(create: (_) => NotificiationNotifier())
    ],
    child: const NewsApp()
  ));
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      return MaterialApp(
        title: 'News App',
        theme: theme.getTheme(),
        home: MyHomePage(title: 'News App', theme: theme),
      );
    });
  }
}
