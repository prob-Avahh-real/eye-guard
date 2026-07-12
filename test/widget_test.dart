import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:eye_guard/providers/settings_provider.dart';
import 'package:eye_guard/providers/timer_provider.dart';
import 'package:eye_guard/providers/stats_provider.dart';
import 'package:eye_guard/screens/home_screen.dart';

Widget _buildTestApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ChangeNotifierProvider(create: (_) => TimerProvider()),
      ChangeNotifierProvider(create: (_) => StatsProvider()),
    ],
    child: const MaterialApp(home: HomeScreen()),
  );
}

void main() {
  testWidgets('HomeScreen renders app title', (WidgetTester tester) async {
    await tester.pumpWidget(_buildTestApp());

    // SliverAppBar 标题立即可见
    expect(find.text('护眼卫士'), findsOneWidget);
    expect(find.text('科学护眼 · 远离疲劳'), findsOneWidget);
  });

  testWidgets('HomeScreen shows quick actions after scroll',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildTestApp());

    // 向下滚动使"快捷操作"部分可见
    await tester.drag(find.byType(HomeScreen), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.text('快捷操作'), findsOneWidget);
    expect(find.text('推荐眼部运动'), findsOneWidget);
  });
}
