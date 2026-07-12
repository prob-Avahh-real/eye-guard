import 'package:flutter/material.dart';
import '../models/exercise.dart';

/// 运动卡片组件
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  Color get _categoryColor {
    switch (exercise.category) {
      case 'relax':
        return Colors.teal;
      case 'focus':
        return Colors.indigo;
      case 'blink':
        return Colors.cyan;
      case 'circulation':
        return Colors.deepPurple;
      default:
        return Colors.blue;
    }
  }

  String get _categoryLabel {
    switch (exercise.category) {
      case 'relax':
        return '放松';
      case 'focus':
        return '聚焦';
      case 'blink':
        return '眨眼';
      case 'circulation':
        return '循环';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // 图标
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _categoryColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(exercise.icon, style: const TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 14),
              // 文字
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exercise.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(150),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 时长 + 类别标签
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _categoryColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _categoryLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: _categoryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${exercise.durationSeconds}s',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(180),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withAlpha(100)),
            ],
          ),
        ),
      ),
    );
  }
}
