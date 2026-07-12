import 'package:flutter/material.dart';
import '../models/daily_record.dart';
import 'package:intl/intl.dart';

/// 统计数据提供者
class StatsProvider extends ChangeNotifier {
  DailyRecord? _todayRecord;
  List<DailyRecord> _weekRecords = [];

  DailyRecord? get todayRecord => _todayRecord;
  List<DailyRecord> get weekRecords => _weekRecords;

  Future<void> loadToday() async {
    final now = DateTime.now();
    final key = DateFormat('yyyy-MM-dd').format(now);
    _todayRecord = await DailyRecord.load(key);
    notifyListeners();
  }

  Future<void> loadWeek() async {
    final now = DateTime.now();
    _weekRecords = [];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(date);
      final record = await DailyRecord.load(key);
      _weekRecords.add(record);
    }
    notifyListeners();
  }

  /// 本周总完成次数
  int get weekTimerTotal =>
      _weekRecords.fold(0, (sum, r) => sum + r.timerRemindersCompleted);

  /// 本周运动完成数
  int get weekExerciseTotal =>
      _weekRecords.fold(0, (sum, r) => sum + r.exercisesCompleted);

  /// 本周总休息时长（分钟）
  int get weekBreakMinutes =>
      _weekRecords.fold(0, (sum, r) => sum + r.totalBreakSeconds) ~/ 60;

  /// 今日完成度百分比（基于建议值：每小时 3 次提醒，8 小时 = 24 次）
  double get todayCompletionPercent {
    if (_todayRecord == null) return 0;
    final target = 24;
    return (_todayRecord!.timerRemindersCompleted / target).clamp(0.0, 1.0);
  }

  /// 连续达标天数
  int get streakDays {
    int streak = 0;
    for (int i = _weekRecords.length - 1; i >= 0; i--) {
      if (_weekRecords[i].timerRemindersCompleted >= 3) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  /// 本周每日提醒次数（用于图表）
  List<double> get dailyCompletions =>
      _weekRecords.map((r) => r.timerRemindersCompleted.toDouble()).toList();
}
