import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../providers/settings_provider.dart';

/// 20-20-20 定时器页面
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timer = context.watch<TimerProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('20-20-20 法则'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // 状态标签
            _buildStatusBadge(timer.state, theme),

            const SizedBox(height: 30),

            // 圆形进度
            _buildCircularProgress(timer, theme),

            const SizedBox(height: 30),

            // 剩余时间文字
            Text(
              timer.state == TimerState.working ? '距离下次休息' : '休息剩余',
              style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(160)),
            ),
            const SizedBox(height: 6),
            Text(
              _formatTime(timer.remainingSeconds),
              style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _getStateColor(timer.state)),
            ),

            const SizedBox(height: 24),

            // 提示语
            if (timer.state == TimerState.onBreak)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Text('🌿', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '请将视线移开屏幕，看向远处（至少 6 米）',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),

            const Spacer(),

            // 控制按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: _buildControlButtons(timer, settings),
            ),

            const SizedBox(height: 12),

            // 今日统计
            if (timer.todayRecord != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '今日已完成 ${timer.todayRecord!.timerRemindersCompleted} 次休息提醒',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(130)),
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TimerState state, ThemeData theme) {
    String label;
    Color color;
    IconData icon;

    switch (state) {
      case TimerState.idle:
        label = '准备就绪';
        color = Colors.grey;
        icon = Icons.radio_button_unchecked;
        break;
      case TimerState.working:
        label = '工作中';
        color = Colors.blue;
        icon = Icons.laptop;
        break;
      case TimerState.onBreak:
        label = '休息中';
        color = Colors.teal;
        icon = Icons.self_improvement;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildCircularProgress(
      TimerProvider timer, ThemeData theme) {
    final size = 220.0;
    final color = _getStateColor(timer.state);

    if (timer.state == TimerState.onBreak) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulse = timer.state == TimerState.onBreak
            ? 1.0 + _pulseController.value * 0.04
            : 1.0;

        return Transform.scale(
          scale: pulse,
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 背景圆环
                CustomPaint(
                  painter: _CircularBgPainter(color: color.withAlpha(30)),
                ),
                // 进度圆环
                CustomPaint(
                  painter: _CircularProgressPainter(
                    progress: timer.progress,
                    color: color,
                  ),
                ),
                // 中心图标
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getCenterEmoji(timer.state),
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getCenterLabel(timer.state),
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: color, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButtons(
      TimerProvider timer, SettingsProvider settings) {
    if (timer.state == TimerState.idle) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: FilledButton.icon(
          onPressed: () {
            timer.configure(settings.workMinutes, settings.breakSeconds);
            timer.start();
          },
          icon: const Icon(Icons.play_arrow),
          label: Text(
              '开始计时 (${settings.workMinutes}分钟工作 / ${settings.breakSeconds}秒休息)'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.teal,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 停止按钮
        OutlinedButton.icon(
          onPressed: timer.stop,
          icon: const Icon(Icons.stop, color: Colors.red),
          label: const Text('停止',
              style: TextStyle(color: Colors.red)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 12),
          ),
        ),
        const SizedBox(width: 20),
        // 跳过/暂停按钮
        if (timer.state == TimerState.onBreak)
          FilledButton.icon(
            onPressed: () {
              // 跳回工作状态
              timer.stop();
              timer.configure(
                  settings.workMinutes, settings.breakSeconds);
              timer.start();
            },
            icon: const Icon(Icons.skip_next),
            label: const Text('跳过休息'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
            ),
          ),
      ],
    );
  }

  Color _getStateColor(TimerState state) {
    switch (state) {
      case TimerState.idle:
        return Colors.grey;
      case TimerState.working:
        return Colors.blue;
      case TimerState.onBreak:
        return Colors.teal;
    }
  }

  String _getCenterEmoji(TimerState state) {
    switch (state) {
      case TimerState.idle:
        return '⏸️';
      case TimerState.working:
        return '💻';
      case TimerState.onBreak:
        return '🌿';
    }
  }

  String _getCenterLabel(TimerState state) {
    switch (state) {
      case TimerState.idle:
        return '准备开始';
      case TimerState.working:
        return '专注工作中';
      case TimerState.onBreak:
        return '让眼睛休息';
    }
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

// ── 背景圆环绘制器 ──
class _CircularBgPainter extends CustomPainter {
  final Color color;
  _CircularBgPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2 - 16,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── 进度圆环绘制器 ──
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;
    const startAngle = -1.5708; // -90 degrees in radians

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * 3.14159 * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
