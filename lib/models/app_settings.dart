import 'package:shared_preferences/shared_preferences.dart';

/// 应用设置
class AppSettings {
  // 20-20-20 定时器
  int workMinutes; // 工作间隔（分钟）
  int breakSeconds; // 休息时长（秒）
  bool timerEnabled; // 是否启用定时器

  // 眨眼提醒
  bool blinkReminderEnabled;
  int blinkIntervalMinutes;

  // 通知
  bool notificationsEnabled;

  // 主题
  bool darkMode;

  AppSettings({
    this.workMinutes = 20,
    this.breakSeconds = 20,
    this.timerEnabled = true,
    this.blinkReminderEnabled = false,
    this.blinkIntervalMinutes = 5,
    this.notificationsEnabled = true,
    this.darkMode = false,
  });

  Map<String, dynamic> toJson() => {
        'workMinutes': workMinutes,
        'breakSeconds': breakSeconds,
        'timerEnabled': timerEnabled,
        'blinkReminderEnabled': blinkReminderEnabled,
        'blinkIntervalMinutes': blinkIntervalMinutes,
        'notificationsEnabled': notificationsEnabled,
        'darkMode': darkMode,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        workMinutes: json['workMinutes'] ?? 20,
        breakSeconds: json['breakSeconds'] ?? 20,
        timerEnabled: json['timerEnabled'] ?? true,
        blinkReminderEnabled: json['blinkReminderEnabled'] ?? false,
        blinkIntervalMinutes: json['blinkIntervalMinutes'] ?? 5,
        notificationsEnabled: json['notificationsEnabled'] ?? true,
        darkMode: json['darkMode'] ?? false,
      );

  static Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('app_settings');
    if (data != null) {
      final json = _decode(data);
      if (json != null) return AppSettings.fromJson(json);
    }
    return AppSettings();
  }

  static Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_settings', _encode(settings.toJson()));
  }

  static Map<String, dynamic>? _decode(String data) {
    // 简单 JSON 解码，不使用 dart:convert 以兼容
    try {
      final map = <String, dynamic>{};
      final trimmed = data.trim();
      if (trimmed.isEmpty || trimmed == '{}') return map;
      final inner = trimmed.substring(1, trimmed.length - 1);
      for (final pair in inner.split(',')) {
        final colon = pair.indexOf(':');
        if (colon == -1) continue;
        final key = pair.substring(0, colon).trim().replaceAll('"', '');
        final value = pair.substring(colon + 1).trim();
        if (value == 'true') {
          map[key] = true;
        } else if (value == 'false') {
          map[key] = false;
        } else {
          final num = int.tryParse(value);
          map[key] = num ?? value.replaceAll('"', '');
        }
      }
      return map;
    } catch (_) {
      return null;
    }
  }

  static String _encode(Map<String, dynamic> map) {
    final entries = map.entries
        .map((e) =>
            '"${e.key}": ${e.value is String ? '"${e.value}"' : e.value}')
        .join(',');
    return '{$entries}';
  }
}
