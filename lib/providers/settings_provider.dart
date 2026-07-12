import 'package:flutter/material.dart';
import '../models/app_settings.dart';

/// 全局设置状态管理
class SettingsProvider extends ChangeNotifier {
  AppSettings _settings = AppSettings();

  AppSettings get settings => _settings;

  // 便利访问器
  int get workMinutes => _settings.workMinutes;
  int get breakSeconds => _settings.breakSeconds;
  bool get timerEnabled => _settings.timerEnabled;
  bool get blinkReminderEnabled => _settings.blinkReminderEnabled;
  bool get notificationsEnabled => _settings.notificationsEnabled;
  bool get darkMode => _settings.darkMode;

  Future<void> load() async {
    _settings = await AppSettings.load();
    notifyListeners();
  }

  Future<void> updateWorkMinutes(int minutes) async {
    _settings.workMinutes = minutes;
    await AppSettings.save(_settings);
    notifyListeners();
  }

  Future<void> updateBreakSeconds(int seconds) async {
    _settings.breakSeconds = seconds;
    await AppSettings.save(_settings);
    notifyListeners();
  }

  Future<void> toggleTimer() async {
    _settings.timerEnabled = !_settings.timerEnabled;
    await AppSettings.save(_settings);
    notifyListeners();
  }

  Future<void> toggleBlinkReminder() async {
    _settings.blinkReminderEnabled = !_settings.blinkReminderEnabled;
    await AppSettings.save(_settings);
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    _settings.notificationsEnabled = !_settings.notificationsEnabled;
    await AppSettings.save(_settings);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _settings.darkMode = !_settings.darkMode;
    await AppSettings.save(_settings);
    notifyListeners();
  }
}
