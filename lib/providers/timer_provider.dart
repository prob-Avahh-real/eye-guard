import 'dart:async';
import 'package:flutter/material.dart';
import '../models/daily_record.dart';

/// 20-20-20 定时器状态管理
enum TimerState { idle, working, onBreak }

class TimerProvider extends ChangeNotifier {
  TimerState _state = TimerState.idle;
  int _elapsedSeconds = 0;
  int _workDurationSeconds = 20 * 60; // 默认 20 分钟
  int _breakDurationSeconds = 20; // 默认 20 秒
  Timer? _timer;
  DailyRecord? _todayRecord;

  TimerState get state => _state;
  int get elapsedSeconds => _elapsedSeconds;
  int get workDurationSeconds => _workDurationSeconds;
  int get breakDurationSeconds => _breakDurationSeconds;
  int get remainingSeconds =>
      _state == TimerState.working
          ? _workDurationSeconds - _elapsedSeconds
          : _breakDurationSeconds - _elapsedSeconds;
  double get progress =>
      _state == TimerState.working
          ? _elapsedSeconds / _workDurationSeconds
          : _elapsedSeconds / _breakDurationSeconds;
  DailyRecord? get todayRecord => _todayRecord;

  void configure(int workMinutes, int breakSeconds) {
    _workDurationSeconds = workMinutes * 60;
    _breakDurationSeconds = breakSeconds;
  }

  Future<void> start() async {
    _todayRecord = await DailyRecord.load(
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}');
    _state = TimerState.working;
    _elapsedSeconds = 0;
    _startTicking();
    notifyListeners();
  }

  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;

      if (_state == TimerState.working &&
          _elapsedSeconds >= _workDurationSeconds) {
        // 切换到休息
        _state = TimerState.onBreak;
        _elapsedSeconds = 0;
        notifyListeners();
      } else if (_state == TimerState.onBreak &&
          _elapsedSeconds >= _breakDurationSeconds) {
        // 休息结束，完成一轮
        _completeBreak();
      } else {
        notifyListeners();
      }
    });
  }

  void _completeBreak() {
    _state = TimerState.working;
    _elapsedSeconds = 0;
    if (_todayRecord != null) {
      _todayRecord!.timerRemindersCompleted++;
      _todayRecord!.totalBreakSeconds += _breakDurationSeconds;
      DailyRecord.save(_todayRecord!);
    }
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    notifyListeners();
  }

  void resume() {
    _startTicking();
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _state = TimerState.idle;
    _elapsedSeconds = 0;
    notifyListeners();
  }

  void recordExercise() {
    if (_todayRecord != null) {
      _todayRecord!.exercisesCompleted++;
      DailyRecord.save(_todayRecord!);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
