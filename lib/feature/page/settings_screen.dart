import 'package:flutter/material.dart';
import 'package:news_app/core/data/datasource/remote_news_datasource.dart';
import 'package:news_app/core/data/model/news_model.dart';
import 'package:news_app/core/data/model/source_model.dart';
import 'package:news_app/core/resource/notification_service.dart';
import 'package:news_app/core/resource/notificiation_notifier.dart';
import 'package:news_app/core/resource/theme_manager.dart';
import 'package:news_app/core/resource/theme_notifier.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.theme, required this.notif});

  final ThemeNotifier theme;
  final NotificiationNotifier notif;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _isNotificationEnabled = false;
  NewsModel _newsModel = NewsModel(
      source: SourceModel(id: 0, name: null),
      author: null,
      title: null,
      description: null,
      url: null,
      urlToImage: null,
      publishedAt: null,
      content: null);

  @override
  Widget build(BuildContext context) {
    ThemeManager().readSettings().then((value) => setState(() {
          _isDarkMode = value;
        }));
    NotificationService().readSettings().then((value) => setState(() {
          _isNotificationEnabled = value;
        }));
    NewsRemoteDataSource().fetchTopHeadlines().then((value) {
      NewsModel news =
          value.where((model) => model.description.toString() != 'null').first;
      setState(() {
        _newsModel = news;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Change Theme'),
                Switch(
                    value: _isDarkMode,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (bool value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                      if (value == true) {
                        widget.theme.setDarkMode();
                      } else {
                        widget.theme.setLightMode();
                      }
                    })
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Enable News Notification Every 10.00AM'),
                Switch(
                    value: _isNotificationEnabled,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (bool value) {
                      setState(() {
                        _isNotificationEnabled = value;
                      });
                      if (value == true) {
                        widget.notif.enableNotification(_newsModel, context, widget.theme);
                      } else {
                        widget.notif.disableNotification();
                      }
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
