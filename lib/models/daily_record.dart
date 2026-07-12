import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 每日追踪记录
class DailyRecord {
  final DateTime date;
  int timerRemindersCompleted; // 20-20-20 完成次数
  int exercisesCompleted; // 完成的运动数
  int blinkRemindersCompleted; // 眨眼提醒完成数
  int totalBreakSeconds; // 总休息时长（秒）

  DailyRecord({
    required this.date,
    this.timerRemindersCompleted = 0,
    this.exercisesCompleted = 0,
    this.blinkRemindersCompleted = 0,
    this.totalBreakSeconds = 0,
  });

  factory DailyRecord.today() => DailyRecord(date: DateTime.now());

  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'timerRemindersCompleted': timerRemindersCompleted,
        'exercisesCompleted': exercisesCompleted,
        'blinkRemindersCompleted': blinkRemindersCompleted,
        'totalBreakSeconds': totalBreakSeconds,
      };

  factory DailyRecord.fromJson(Map<String, dynamic> json) => DailyRecord(
        date: DateTime.parse(json['date']),
        timerRemindersCompleted: json['timerRemindersCompleted'] ?? 0,
        exercisesCompleted: json['exercisesCompleted'] ?? 0,
        blinkRemindersCompleted: json['blinkRemindersCompleted'] ?? 0,
        totalBreakSeconds: json['totalBreakSeconds'] ?? 0,
      );

  static Future<DailyRecord> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('record_$key');
    if (data != null) {
      return DailyRecord.fromJson(jsonDecode(data));
    }
    return DailyRecord(date: DateTime.now());
  }

  static Future<void> save(DailyRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'record_${record.dateKey}', jsonEncode(record.toJson()));
  }
}
