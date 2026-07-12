import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

/// 设置页面
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          // ── 20-20-20 定时器设置 ──
          _SectionHeader(title: '20-20-20 定时器', icon: Icons.timer),
          SwitchListTile(
            title: const Text('启用定时提醒'),
            subtitle: const Text('自动在工作和休息之间切换'),
            value: settings.timerEnabled,
            onChanged: (_) => settings.toggleTimer(),
            secondary: const Icon(Icons.notifications_active, color: Colors.teal),
          ),
          ListTile(
            leading: const Icon(Icons.work, color: Colors.blue),
            title: const Text('工作间隔'),
            subtitle: Text('${settings.workMinutes} 分钟'),
            trailing: SizedBox(
              width: 160,
              child: Slider(
                value: settings.workMinutes.toDouble(),
                min: 10,
                max: 60,
                divisions: 10,
                label: '${settings.workMinutes} 分钟',
                onChanged: (val) =>
                    settings.updateWorkMinutes(val.round()),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.self_improvement, color: Colors.teal),
            title: const Text('休息时长'),
            subtitle: Text('${settings.breakSeconds} 秒'),
            trailing: SizedBox(
              width: 160,
              child: Slider(
                value: settings.breakSeconds.toDouble(),
                min: 10,
                max: 60,
                divisions: 10,
                label: '${settings.breakSeconds} 秒',
                onChanged: (val) =>
                    settings.updateBreakSeconds(val.round()),
              ),
            ),
          ),
          const Divider(height: 32),

          // ── 眨眼提醒 ──
          _SectionHeader(title: '眨眼提醒', icon: Icons.remove_red_eye),
          SwitchListTile(
            title: const Text('启用眨眼提醒'),
            subtitle: const Text('定期提醒你完整眨眼，预防干眼症'),
            value: settings.blinkReminderEnabled,
            onChanged: (_) => settings.toggleBlinkReminder(),
            secondary: const Icon(Icons.water_drop, color: Colors.cyan),
          ),
          const Divider(height: 32),

          // ── 通知 ──
          _SectionHeader(title: '通知', icon: Icons.notifications),
          SwitchListTile(
            title: const Text('启用通知'),
            subtitle: const Text('接收休息提醒和护眼建议推送'),
            value: settings.notificationsEnabled,
            onChanged: (_) => settings.toggleNotifications(),
            secondary: const Icon(Icons.notifications_active, color: Colors.orange),
          ),
          const Divider(height: 32),

          // ── 外观 ──
          _SectionHeader(title: '外观', icon: Icons.palette),
          SwitchListTile(
            title: const Text('深色模式'),
            subtitle: const Text('使用深色主题，减少屏幕亮度刺激'),
            value: settings.darkMode,
            onChanged: (_) => settings.toggleDarkMode(),
            secondary: const Icon(Icons.dark_mode, color: Colors.indigo),
          ),
          const Divider(height: 32),

          // ── 关于 ──
          _SectionHeader(title: '关于', icon: Icons.info_outline),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.blueGrey),
            title: const Text('护眼卫士'),
            subtitle: const Text('版本 1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.medical_services, color: Colors.red),
            title: const Text('免责声明'),
            subtitle: const Text(
                '本应用提供护眼建议仅供参考，不构成医疗诊断。如有眼部不适，请及时就医。'),
            subtitleTextStyle: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withAlpha(130)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
