import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'providers/timer_provider.dart';
import 'providers/stats_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 加载设置
  final settingsProvider = SettingsProvider();
  await settingsProvider.load();

  runApp(EyeGuardApp(settingsProvider: settingsProvider));
}

class EyeGuardApp extends StatelessWidget {
  final SettingsProvider settingsProvider;

  const EyeGuardApp({super.key, required this.settingsProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => StatsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: '护眼卫士',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              fontFamily: null, // 使用系统默认字体
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode:
                settings.darkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
