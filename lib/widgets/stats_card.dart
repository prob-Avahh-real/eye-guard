import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stats_provider.dart';
import 'package:fl_chart/fl_chart.dart';

/// 统计卡片组件
class StatsCard extends StatelessWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<StatsProvider>(
      builder: (context, stats, _) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('本周数据',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    if (stats.streakDays > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Colors.amber, Colors.orange]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text('连续 ${stats.streakDays} 天',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // 三个统计数字
                Row(
                  children: [
                    _StatItem(
                        icon: Icons.timer,
                        label: '休息提醒',
                        value: '${stats.weekTimerTotal}',
                        color: Colors.teal),
                    _StatItem(
                        icon: Icons.fitness_center,
                        label: '眼运动',
                        value: '${stats.weekExerciseTotal}',
                        color: Colors.indigo),
                    _StatItem(
                        icon: Icons.bedtime,
                        label: '休息时长',
                        value: '${stats.weekBreakMinutes}分',
                        color: Colors.deepPurple),
                  ],
                ),
                const SizedBox(height: 16),

                // 图表
                SizedBox(
                  height: 140,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (stats.dailyCompletions.isEmpty
                              ? 1
                              : stats.dailyCompletions
                                      .reduce((a, b) => a > b ? a : b) +
                                  5)
                          .toDouble(),
                      barGroups: _buildBarGroups(stats.dailyCompletions),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 5,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: theme.dividerColor.withAlpha(80),
                          strokeWidth: 0.5,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final days = ['一', '二', '三', '四', '五', '六', '日'];
                              final idx = value.toInt();
                              if (idx >= 0 && idx < days.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(days[idx],
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: theme.colorScheme.onSurface
                                              .withAlpha(150))),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: true, reservedSize: 28),
                        ),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<double> values) {
    return List.generate(7, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: i < values.length ? values[i] : 0,
            color: i == 6 ? Colors.teal : Colors.teal.withAlpha(120),
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration:
                BoxDecoration(color: color.withAlpha(25), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700, color: color)),
          Text(label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurface.withAlpha(130))),
        ],
      ),
    );
  }
}
