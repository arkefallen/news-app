import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_app/core/data/model/news_model.dart';
import 'package:news_app/core/resource/notification_service.dart';
import 'package:news_app/core/resource/theme_notifier.dart';

class NotificiationNotifier with ChangeNotifier {
  bool _newsNotificationEnabled = false;
  bool getNotificationEnabled() => _newsNotificationEnabled;

  NotificiationNotifier() {
    NotificationService().readSettings().then((val) {
      _newsNotificationEnabled = val;
      notifyListeners();
    });
  }

  void enableNotification(NewsModel newsModel, BuildContext context, ThemeNotifier theme) async {
    _newsNotificationEnabled = true;
    NotificationService.saveSettings(_newsNotificationEnabled, newsModel, context, theme);
    notifyListeners();
  }

  void disableNotification() async {
    _newsNotificationEnabled = false;
    NotificationService.saveSettings(_newsNotificationEnabled, null, null, null);
    notifyListeners();
  }
}
