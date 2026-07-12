import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stats_provider.dart';
import '../providers/timer_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/stats_card.dart';
import 'timer_screen.dart';
import 'exercises_screen.dart';
import 'knowledge_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatsProvider>().loadToday();
      context.read<StatsProvider>().loadWeek();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = context.watch<StatsProvider>();
    final timer = context.watch<TimerProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 顶部区域
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('护眼卫士',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('👁️',
                          style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 4),
                      Text(
                        '科学护眼 · 远离疲劳',
                        style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  settings.darkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                ),
                onPressed: () =>
                    context.read<SettingsProvider>().toggleDarkMode(),
              ),
            ],
          ),

          // 今日状态
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('今日护眼进度',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  _TodayProgress(stats: stats),
                ],
              ),
            ),
          ),

          // 本周统计
          const SliverToBoxAdapter(child: StatsCard()),

          // 快捷操作
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('快捷操作',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ),
          ),
          SliverToBoxAdapter(
            child: _QuickActions(timer: timer, settings: settings),
          ),

          // 推荐运动
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('推荐眼部运动',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  TextButton(
                    onPressed: () => _navigateTo(context, 2),
                    child: const Text('查看全部'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: _RecommendedExercises()),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: 0,
        onTap: (index) => _navigateTo(context, index),
      ),
    );
  }

  void _navigateTo(BuildContext context, int index) {
    Widget page;
    switch (index) {
      case 0:
        return; // 已在首页
      case 1:
        page = const TimerScreen();
        break;
      case 2:
        page = const ExercisesScreen();
        break;
      case 3:
        page = const KnowledgeScreen();
        break;
      case 4:
        page = const SettingsScreen();
        break;
      default:
        return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

// ── 今日进度 ──
class _TodayProgress extends StatelessWidget {
  final StatsProvider stats;
  const _TodayProgress({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = stats.todayCompletionPercent;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 环形进度
            SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 6,
                    backgroundColor:
                        theme.colorScheme.onSurface.withAlpha(30),
                    color: _getProgressColor(percent),
                  ),
                  Center(
                    child: Text(
                      '${(percent * 100).toInt()}%',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('已完成 ${stats.todayRecord?.timerRemindersCompleted ?? 0} 次休息',
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 4),
                  Text(
                    _getEncouragement(percent),
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: _getProgressColor(percent)),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: theme.colorScheme.onSurface.withAlpha(100)),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double p) {
    if (p >= 0.7) return Colors.green;
    if (p >= 0.3) return Colors.orange;
    return Colors.red;
  }

  String _getEncouragement(double p) {
    if (p >= 0.8) return '🎉 太棒了！眼睛得到了充分休息';
    if (p >= 0.5) return '👍 做得好，继续保持';
    if (p > 0) return '💪 今天还要多注意休息哦';
    return '👀 开始你的护眼之旅吧';
  }
}

// ── 快捷操作 ──
class _QuickActions extends StatelessWidget {
  final TimerProvider timer;
  final SettingsProvider settings;

  const _QuickActions({required this.timer, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.timer,
              label: timer.state == TimerState.idle
                  ? '开始计时'
                  : timer.state == TimerState.working
                      ? '工作中...'
                      : '休息中...',
              color: Colors.teal,
              onTap: () {
                if (timer.state == TimerState.idle) {
                  timer.configure(
                      settings.workMinutes, settings.breakSeconds);
                  timer.start();
                } else {
                  timer.stop();
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionButton(
              icon: Icons.remove_red_eye,
              label: '快速眨眼',
              color: Colors.indigo,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ExercisesScreen())),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionButton(
              icon: Icons.wb_sunny,
              label: '护眼知识',
              color: Colors.amber.shade700,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const KnowledgeScreen())),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── 推荐运动 ──
class _RecommendedExercises extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildRecCard(context, '20-20-20', '远近交替休息', '👁️', Colors.teal,
              'timer_screen'),
          _buildRecCard(context, 'blink', '完整眨眼训练', '😉', Colors.cyan,
              'exercises_screen'),
          _buildRecCard(context, 'palming', '掌敷热敷法', '🤲', Colors.orange,
              'exercises_screen'),
          _buildRecCard(
              context, 'eye-roll', '眼球转动', '🔄', Colors.indigo, 'exercises_screen'),
        ],
      ),
    );
  }

  Widget _buildRecCard(BuildContext context, String id, String title,
      String emoji, Color color, String route) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if (route == 'timer_screen') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const TimerScreen()));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const ExercisesScreen()));
        }
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(50)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 30)),
            const Spacer(),
            Text(title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ── 底部导航 ──
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页'),
        NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: '定时'),
        NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: '运动'),
        NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: '知识'),
        NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: '设置'),
      ],
    );
  }
}
