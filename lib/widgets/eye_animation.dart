import 'dart:math';
import 'package:flutter/material.dart';

/// 眼部运动动画绘制器 — 用于展示眼球移动轨迹
class EyeAnimationPainter extends CustomPainter {
  final double progress; // 0.0 ~ 1.0
  final String exerciseId;

  EyeAnimationPainter({required this.progress, required this.exerciseId});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final eyeRadius = min(size.width, size.height) * 0.22;

    // 画两只眼睛
    _drawEye(canvas, Offset(center.dx - eyeRadius * 1.8, center.dy),
        eyeRadius, size);
    _drawEye(canvas, Offset(center.dx + eyeRadius * 1.8, center.dy),
        eyeRadius, size);
  }

  void _drawEye(Canvas canvas, Offset center, double radius, Size size) {
    final pupilRadius = radius * 0.35;
    final moveRange = radius * 0.5;

    // 眼白
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, eyePaint);

    // 眼轮廓
    final outlinePaint = Paint()
      ..color = Colors.blueGrey.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, radius, outlinePaint);

    // 瞳孔位置 - 根据运动类型计算
    Offset pupilOffset;
    switch (exerciseId) {
      case 'figure-8':
        // ∞ 字形：Lissajous 曲线
        final t = progress * 2 * pi;
        pupilOffset = Offset(
          sin(t) * moveRange,
          sin(2 * t) * moveRange * 0.6,
        );
        break;
      case 'eye-roll':
        // 顺时针转动
        final t = progress * 2 * pi;
        pupilOffset = Offset(cos(t) * moveRange, sin(t) * moveRange);
        break;
      case 'near-far':
        // 远近：收缩-扩张
        final scale = 0.3 + 0.7 * (0.5 + 0.5 * sin(progress * 4 * pi));
        pupilOffset = Offset(
          sin(progress * 2 * pi) * moveRange * scale,
          cos(progress * 2 * pi) * moveRange * scale * 0.3,
        );
        break;
      case 'diagonal':
        // 对角线移动
        final phase = (progress * 4) % 1.0;
        double dx = 0, dy = 0;
        if (phase < 0.25) {
          dx = -1;
          dy = -1;
        } else if (phase < 0.5) {
          dx = 1;
          dy = 1;
        } else if (phase < 0.75) {
          dx = 1;
          dy = -1;
        } else {
          dx = -1;
          dy = 1;
        }
        final t = phase * 4 % 1.0;
        pupilOffset = Offset(dx * moveRange * t, dy * moveRange * t);
        break;
      default:
        // 默认：缓慢移动
        final t = progress * 2 * pi;
        pupilOffset = Offset(sin(t) * moveRange * 0.5, cos(t) * moveRange * 0.3);
    }

    // 瞳孔
    final pupilPaint = Paint()
      ..color = Colors.blueGrey.shade900
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + pupilOffset.dx, center.dy + pupilOffset.dy),
      pupilRadius,
      pupilPaint,
    );

    // 高光
    final highlightPaint = Paint()
      ..color = Colors.white.withAlpha(180)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + pupilOffset.dx - pupilRadius * 0.2,
          center.dy + pupilOffset.dy - pupilRadius * 0.3),
      pupilRadius * 0.25,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant EyeAnimationPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.exerciseId != exerciseId;
}

/// 眼部动画组件
class EyeAnimationWidget extends StatefulWidget {
  final String exerciseId;
  final int durationSeconds;

  const EyeAnimationWidget({
    super.key,
    required this.exerciseId,
    required this.durationSeconds,
  });

  @override
  State<EyeAnimationWidget> createState() => _EyeAnimationWidgetState();
}

class _EyeAnimationWidgetState extends State<EyeAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationSeconds),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: EyeAnimationPainter(
            progress: _controller.value,
            exerciseId: widget.exerciseId,
          ),
          size: const Size(double.infinity, 180),
        );
      },
    );
  }
}
