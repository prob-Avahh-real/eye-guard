import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../widgets/exercise_card.dart';
import 'exercise_detail_screen.dart';

/// 眼部运动列表页面
class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 按类别分组
    final categories = <String, List<Exercise>>{};
    for (final ex in Exercise.all) {
      categories.putIfAbsent(ex.category, () => []).add(ex);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('眼部运动'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          // 顶部说明
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.withAlpha(20), Colors.teal.withAlpha(20)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Text('💡', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '每天花 5 分钟做眼部运动，有效缓解视疲劳，预防干眼症',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),

          // 按类别渲染
          for (final entry in categories.entries) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  Icon(_categoryIcon(entry.key),
                      size: 18, color: _categoryColor(entry.key)),
                  const SizedBox(width: 6),
                  Text(
                    _categoryTitle(entry.key),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _categoryColor(entry.key),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.value.length} 项',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(100)),
                  ),
                ],
              ),
            ),
            for (final ex in entry.value)
              ExerciseCard(
                exercise: ex,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => ExerciseDetailScreen(exercise: ex)),
                  );
                },
              ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'relax':
        return Icons.self_improvement;
      case 'focus':
        return Icons.center_focus_strong;
      case 'blink':
        return Icons.remove_red_eye;
      case 'circulation':
        return Icons.loop;
      default:
        return Icons.fitness_center;
    }
  }

  Color _categoryColor(String category) {
    switch (category) {
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

  String _categoryTitle(String category) {
    switch (category) {
      case 'relax':
        return '放松';
      case 'focus':
        return '聚焦训练';
      case 'blink':
        return '眨眼练习';
      case 'circulation':
        return '眼部循环';
      default:
        return category;
    }
  }
}
