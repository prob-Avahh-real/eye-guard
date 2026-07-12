import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../widgets/eye_animation.dart';
import '../providers/timer_provider.dart';

/// 运动详情 + 引导页面
class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  int _currentStep = 0;
  int _stepElapsed = 0;
  Timer? _stepTimer;
  bool _isRunning = false;
  bool _isCompleted = false;

  ExerciseStep get _step => widget.exercise.steps[_currentStep];

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }

  void _startExercise() {
    setState(() {
      _isRunning = true;
      _currentStep = 0;
      _stepElapsed = 0;
      _isCompleted = false;
    });
    _runStep();
  }

  void _runStep() {
    _stepTimer?.cancel();
    final step = widget.exercise.steps[_currentStep];
    setState(() => _stepElapsed = 0);

    _stepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _stepElapsed++);

      if (_stepElapsed >= step.durationSeconds) {
        if (_currentStep < widget.exercise.steps.length - 1) {
          setState(() {
            _currentStep++;
            _stepElapsed = 0;
          });
          _runStep();
        } else {
          // 运动完成
          _completeExercise();
        }
      }
    });
  }

  void _completeExercise() {
    _stepTimer?.cancel();
    setState(() {
      _isCompleted = true;
      _isRunning = false;
    });
    // 记录到统计
    context.read<TimerProvider>().recordExercise();
  }

  void _resetExercise() {
    _stepTimer?.cancel();
    setState(() {
      _isRunning = false;
      _isCompleted = false;
      _currentStep = 0;
      _stepElapsed = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = widget.exercise;

    return Scaffold(
      appBar: AppBar(
        title: Text(ex.name),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 眼部动画
            EyeAnimationWidget(
              exerciseId: ex.id,
              durationSeconds: ex.durationSeconds,
            ),

            // 运动名称
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(ex.icon, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 8),
                  Text(ex.name,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ),

            // 步骤引导
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withAlpha(80),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _isCompleted
                    ? _buildCompletedView(theme)
                    : _isRunning
                        ? _buildRunningView(theme)
                        : _buildReadyView(theme),
              ),
            ),

            // 底部控制按钮
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: _isCompleted
                      ? Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _resetExercise,
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14)),
                                ),
                                child: const Text('再来一次'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: () => Navigator.pop(context),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14)),
                                ),
                                child: const Text('完成 ✓'),
                              ),
                            ),
                          ],
                        )
                      : FilledButton.icon(
                          onPressed: _isRunning ? _resetExercise : _startExercise,
                          icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
                          label: Text(_isRunning ? '停止' : '开始运动'),
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                _isRunning ? Colors.red : Colors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadyView(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('运动步骤',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('总时长：${widget.exercise.durationSeconds} 秒',
            style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(130))),
        const SizedBox(height: 12),
        ...widget.exercise.steps.asMap().entries.map((entry) {
          final idx = entry.key;
          final step = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.teal.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('${idx + 1}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.teal)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step.instruction,
                          style: theme.textTheme.bodyMedium),
                      Text('${step.durationSeconds} 秒',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withAlpha(100))),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRunningView(ThemeData theme) {
    final totalSteps = widget.exercise.steps.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 步骤进度
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSteps, (i) {
            return Container(
              width: 24,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: i <= _currentStep
                    ? Colors.teal
                    : theme.colorScheme.onSurface.withAlpha(50),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),

        // 当前步骤号
        Text(
          '步骤 ${_currentStep + 1} / $totalSteps',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.teal,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),

        // 当前指令
        Icon(
          _isRunning ? Icons.directions_run : Icons.access_time,
          color: Colors.teal,
          size: 40,
        ),
        const SizedBox(height: 12),
        Text(
          _step.instruction,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),

        // 倒计时
        Text(
          '${_step.durationSeconds - _stepElapsed}',
          style: theme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.teal,
          ),
        ),
        Text('秒',
            style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(100))),
      ],
    );
  }

  Widget _buildCompletedView(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🎉', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        Text('运动完成！',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700, color: Colors.green)),
        const SizedBox(height: 8),
        Text(
          '${widget.exercise.name} 已完成，眼睛得到了充分锻炼',
          style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(150)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          '💧 建议喝口水，眨眨眼',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.blue),
        ),
      ],
    );
  }
}
